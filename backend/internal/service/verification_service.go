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
	adminRepo        *repository.AdminRepository
	emailService     *EmailService
}

// NewVerificationService 创建验证码服务
func NewVerificationService() *VerificationService {
	return &VerificationService{
		verificationRepo: repository.NewVerificationCodeRepository(),
		userRepo:         repository.NewUserRepository(),
		adminRepo:        repository.NewAdminRepository(),
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
	// 参数验证
	if phone == "" && email == "" {
		return errors.New("手机号和邮箱不能同时为空")
	}

	// 如果是注册类型，检查是否已存在
	if codeType == 1 { // 注册
		if phone != "" {
			existUser, _ := s.userRepo.FindByPhone(phone)
			if existUser != nil {
				return errors.New("该手机号已被注册，请直接登录")
			}
			// 也检查管理员
			existAdmin, _ := s.adminRepo.FindByPhone(phone)
			if existAdmin != nil {
				return errors.New("该手机号已被注册，请直接登录")
			}
		}
		if email != "" {
			existUser, _ := s.userRepo.FindByEmail(email)
			if existUser != nil {
				return errors.New("该邮箱已被注册，请直接登录")
			}
			// 也检查管理员
			existAdmin, _ := s.adminRepo.FindByEmail(email)
			if existAdmin != nil {
				return errors.New("该邮箱已被注册，请直接登录")
			}
		}
	}

	// 如果是找回密码类型，检查用户是否存在
	if codeType == 2 { // 找回密码
		var userExists bool = false
		
		if phone != "" {
			// 检查客户端用户
			existUser, _ := s.userRepo.FindByPhone(phone)
			if existUser != nil {
				userExists = true
			}
			// 检查管理员
			existAdmin, _ := s.adminRepo.FindByPhone(phone)
			if existAdmin != nil {
				userExists = true
			}
		} else if email != "" {
			// 检查客户端用户
			existUser, _ := s.userRepo.FindByEmail(email)
			if existUser != nil {
				userExists = true
			}
			// 检查管理员
			existAdmin, _ := s.adminRepo.FindByEmail(email)
			if existAdmin != nil {
				userExists = true
			}
		}
		
		if !userExists {
			return errors.New("该账号不存在，请先注册")
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
		return errors.New("发送验证码失败，请稍后重试")
	}

	// 发送验证码
	if phone != "" {
		// TODO: 集成短信服务（如阿里云SMS）
		logger.Info("发送短信验证码", zap.String("phone", phone), zap.String("code", code))
		fmt.Printf("[SMS] 验证码: %s (手机号: %s)\n", code, phone)
	} else {
		// 发送邮件验证码
		if err := s.emailService.SendVerificationCode(email, code); err != nil {
			logger.Error("发送邮件验证码失败", err)
			return errors.New("发送邮件验证码失败，请检查邮箱地址")
		}
		logger.Info("发送邮件验证码", zap.String("email", email))
	}

	return nil
}

// VerifyCode 验证验证码（仅验证，不标记为已使用）
func (s *VerificationService) VerifyCode(phone, email, code string, codeType int) error {
	// 参数验证
	if code == "" {
		return errors.New("验证码不能为空")
	}
	
	if phone == "" && email == "" {
		return errors.New("手机号或邮箱不能为空")
	}

	// 查找有效的验证码
	verificationCode, err := s.verificationRepo.FindValidCode(phone, email, codeType)
	if err != nil {
		logger.Error("查询验证码失败", err)
		return errors.New("服务器错误，请稍后重试")
	}

	if verificationCode == nil {
		return errors.New("验证码无效或已过期，请重新获取")
	}

	// 验证验证码是否正确
	if verificationCode.Code != code {
		return errors.New("验证码错误，请重新输入")
	}

	// 注意：这里不标记为已使用，只在注册/重置密码成功后才标记
	// 这样如果后续操作失败，用户可以重新尝试
	return nil
}

// ResetPassword 重置密码（支持管理端和用户端）
func (s *VerificationService) ResetPassword(phone, email, code, newPassword string) error {
	// 参数验证
	if newPassword == "" {
		return errors.New("新密码不能为空")
	}
	
	if len(newPassword) < 6 {
		return errors.New("密码长度至少为6位")
	}

	// 先验证验证码（不标记为已使用）
	if err := s.VerifyCode(phone, email, code, 2); err != nil { // 2 = 找回密码
		return err
	}

	// 先尝试查找管理员
	var admin *model.Admin
	var client *model.Client
	var err error
	var isClient bool = true

	if phone != "" {
		admin, _ = s.adminRepo.FindByPhone(phone)
		if admin == nil {
			client, err = s.userRepo.FindByPhone(phone)
		} else {
			isClient = false
		}
	} else if email != "" {
		admin, _ = s.adminRepo.FindByEmail(email)
		if admin == nil {
			client, err = s.userRepo.FindByEmail(email)
		} else {
			isClient = false
		}
	}

	if err != nil {
		logger.Error("查询用户失败", err)
		return errors.New("服务器错误，请稍后重试")
	}

	// 更新密码
	if !isClient && admin != nil {
		// 管理员重置密码
		if err := s.adminRepo.UpdatePassword(admin.ID, newPassword); err != nil {
			logger.Error("更新管理员密码失败", err, zap.Int("admin_id", admin.ID))
			return errors.New("重置密码失败，请稍后重试")
		}
		logger.Info("管理员密码重置成功", zap.Int("admin_id", admin.ID))
	} else if client != nil {
		// 客户端用户重置密码
		if err := s.userRepo.UpdatePassword(client.ID, newPassword); err != nil {
			logger.Error("更新用户密码失败", err, zap.Int("user_id", client.ID))
			return errors.New("重置密码失败，请稍后重试")
		}
		logger.Info("用户密码重置成功", zap.Int("user_id", client.ID))
	} else {
		return errors.New("用户不存在")
	}

	// 密码重置成功后，标记验证码为已使用
	logger.Info("准备标记验证码为已使用", 
		zap.String("phone", phone),
		zap.String("email", email),
		zap.Int("type", 2))
	
	verificationCode, findErr := s.verificationRepo.FindValidCode(phone, email, 2)
	if findErr != nil {
		logger.Warn("查找验证码失败", zap.Error(findErr))
	} else if verificationCode == nil {
		logger.Warn("未找到有效的验证码，可能已被使用或过期",
			zap.String("phone", phone),
			zap.String("email", email))
	} else {
		if markErr := s.verificationRepo.MarkAsUsed(verificationCode.ID); markErr != nil {
			logger.Warn("标记验证码为已使用失败", zap.Error(markErr))
		} else {
			logger.Info("✅ 验证码已标记为已使用", 
				zap.Int("code_id", verificationCode.ID),
				zap.String("code", verificationCode.Code))
		}
	}

	return nil
}

// RetrievePassword 找回密码（返回明文密码）
func (s *VerificationService) RetrievePassword(phone, email, code string) (string, error) {
	// 先验证验证码（不标记为已使用）
	if err := s.VerifyCode(phone, email, code, 2); err != nil { // 2 = 找回密码
		return "", err
	}

	// 先尝试查找管理员
	var admin *model.Admin
	var client *model.Client
	var err error
	var isClient bool = true
	var password string

	if phone != "" {
		admin, _ = s.adminRepo.FindByPhone(phone)
		if admin == nil {
			client, err = s.userRepo.FindByPhone(phone)
		} else {
			isClient = false
			password = admin.Password
		}
	} else if email != "" {
		admin, _ = s.adminRepo.FindByEmail(email)
		if admin == nil {
			client, err = s.userRepo.FindByEmail(email)
		} else {
			isClient = false
			password = admin.Password
		}
	}

	if err != nil {
		logger.Error("查询用户失败", err)
		return "", errors.New("服务器错误，请稍后重试")
	}

	// 获取密码
	if !isClient && admin != nil {
		// 管理员密码
		password = admin.Password
		logger.Info("管理员密码找回成功", zap.Int("admin_id", admin.ID))
	} else if client != nil {
		// 客户端用户密码
		password = client.Password
		logger.Info("用户密码找回成功", zap.Int("user_id", client.ID))
	} else {
		return "", errors.New("用户不存在")
	}

	// 密码找回成功后，标记验证码为已使用
	logger.Info("准备标记验证码为已使用", 
		zap.String("phone", phone),
		zap.String("email", email),
		zap.Int("type", 2))
	
	verificationCode, findErr := s.verificationRepo.FindValidCode(phone, email, 2)
	if findErr != nil {
		logger.Warn("查找验证码失败", zap.Error(findErr))
	} else if verificationCode == nil {
		logger.Warn("未找到有效的验证码，可能已被使用或过期",
			zap.String("phone", phone),
			zap.String("email", email))
	} else {
		if markErr := s.verificationRepo.MarkAsUsed(verificationCode.ID); markErr != nil {
			logger.Warn("标记验证码为已使用失败", zap.Error(markErr))
		} else {
			logger.Info("✅ 验证码已标记为已使用", 
				zap.Int("code_id", verificationCode.ID),
				zap.String("code", verificationCode.Code))
		}
	}

	return password, nil
}
