package service

import (
	"errors"
	"fmt"
	"math/rand"
	"time"
	"ttlock-backend/internal/config"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/repository"
	"ttlock-backend/pkg/logger"

	"go.uber.org/zap"
)

// VerificationService 验证码服务
type VerificationService struct {
	verificationRepo *repository.VerificationCodeRepository
	userRepo         *repository.UserRepository
	emailService     *EmailService
}

// NewVerificationService 创建验证码服务
func NewVerificationService() *VerificationService {
	return &VerificationService{
		verificationRepo: repository.NewVerificationCodeRepository(),
		userRepo:         repository.NewUserRepository(),
		emailService:     NewEmailService(&config.GlobalConfig.Email),
	}
}

// generateCode 生成随机验证码
func (s *VerificationService) generateCode() string {
	rand.Seed(time.Now().UnixNano())
	return fmt.Sprintf("%06d", rand.Intn(1000000))
}

// SendCode 发送验证码
func (s *VerificationService) SendCode(phone, email string, codeType int) error {
	// 验证手机号或邮箱
	if phone == "" && email == "" {
		return errors.New("手机号和邮箱不能同时为空")
	}

	// 如果是注册类型，检查是否已存在
	if codeType == 1 { // 注册
		if phone != "" {
			existUser, _ := s.userRepo.FindByPhone(phone)
			if existUser != nil {
				return errors.New("该手机号已注册")
			}
		}
		if email != "" {
			existUser, _ := s.userRepo.FindByEmail(email)
			if existUser != nil {
				return errors.New("该邮箱已注册")
			}
		}
	}

	// 过期旧的验证码
	s.verificationRepo.ExpireOldCodes(phone, email, codeType)

	// 生成新验证码
	code := s.generateCode()

	// 设置过期时间（5分钟）
	expireAt := time.Now().Add(5 * time.Minute)

	// 创建验证码记录
	verificationCode := &model.VerificationCode{
		Phone:    &phone,
		Email:    &email,
		Code:     code,
		Type:     codeType,
		Status:   0, // 未使用
		ExpireAt: expireAt,
	}

	if err := s.verificationRepo.Create(verificationCode); err != nil {
		logger.Error("创建验证码失败", err)
		return errors.New("发送验证码失败")
	}

	// 发送验证码
	if phone != "" {
		// TODO: 集成短信服务（如阿里云SMS）
		logger.Info("发送短信验证码", zap.String("phone", phone), zap.String("code", code))
		fmt.Printf("[SMS] 验证码: %s (手机号: %s)\n", code, phone)
		// 示例：使用阿里云SMS
		// if config.GlobalConfig.SMS.Enabled {
		// 	smsService := NewSMSService(&config.GlobalConfig.SMS)
		// 	if err := smsService.SendVerificationCode(phone, code); err != nil {
		// 		logger.Error("发送短信失败", err)
		// 		return errors.New("发送短信验证码失败")
		// 	}
		// }
	} else {
		// 发送邮件验证码
		if err := s.emailService.SendVerificationCode(email, code); err != nil {
			logger.Error("发送邮件验证码失败", err)
			return errors.New("发送邮件验证码失败")
		}
		logger.Info("发送邮件验证码", zap.String("email", email))
	}

	return nil
}

// VerifyCode 验证验证码
func (s *VerificationService) VerifyCode(phone, email, code string, codeType int) error {
	// 查找有效的验证码
	verificationCode, err := s.verificationRepo.FindValidCode(phone, email, codeType)
	if err != nil {
		logger.Error("查询验证码失败", err)
		return errors.New("验证失败")
	}

	if verificationCode == nil {
		return errors.New("验证码无效或已过期")
	}

	// 验证验证码是否正确
	if verificationCode.Code != code {
		return errors.New("验证码错误")
	}

	// 标记为已使用
	if err := s.verificationRepo.MarkAsUsed(verificationCode.ID); err != nil {
		logger.Error("更新验证码状态失败", err)
	}

	return nil
}

// ResetPassword 重置密码
func (s *VerificationService) ResetPassword(phone, email, code, newPassword string) error {
	// 先验证验证码
	if err := s.VerifyCode(phone, email, code, 2); err != nil { // 2 = 找回密码
		return err
	}

	// 查找用户
	var user *model.Client
	var err error

	if phone != "" {
		user, err = s.userRepo.FindByPhone(phone)
	} else {
		user, err = s.userRepo.FindByEmail(email)
	}

	if err != nil {
		logger.Error("查询用户失败", err)
		return errors.New("重置密码失败")
	}

	if user == nil {
		return errors.New("用户不存在")
	}

	// 更新密码
	if err := s.userRepo.UpdatePassword(user.ID, newPassword); err != nil {
		logger.Error("更新密码失败", err)
		return errors.New("重置密码失败")
	}

	logger.Info("密码重置成功", zap.Int("user_id", user.ID))
	return nil
}
