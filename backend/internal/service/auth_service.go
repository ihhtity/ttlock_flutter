package service

import (
	"errors"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/repository"
	"ttlock-backend/pkg/jwt"
	"ttlock-backend/pkg/logger"
	"go.uber.org/zap"
)

// AuthService 认证服务
type AuthService struct {
	userRepo *repository.UserRepository
}

// NewAuthService 创建认证服务
func NewAuthService() *AuthService {
	return &AuthService{
		userRepo: repository.NewUserRepository(),
	}
}

// Login 用户登录
func (s *AuthService) Login(phone, password string) (*model.LoginResponse, error) {
	// 查找用户
	user, err := s.userRepo.FindByPhone(phone)
	if err != nil {
		logger.Error("查询用户失败", err, zap.String("phone", phone))
		return nil, errors.New("服务器错误")
	}

	if user == nil {
		return nil, errors.New("用户不存在")
	}

	// 检查用户状态
	if user.Status != 1 {
		return nil, errors.New("账号已被禁用")
	}

	// 验证密码
	if !s.userRepo.VerifyPassword(user.Password, password) {
		return nil, errors.New("密码错误")
	}

	// 生成 Token
	token, err := jwt.GenerateToken(user.ID, user.AdminsID, 0, 24)
	if err != nil {
		logger.Error("生成Token失败", err)
		return nil, errors.New("服务器错误")
	}

	// 更新最后登录时间
	s.userRepo.UpdateLastLogin(user.ID)

	// 返回响应
	return &model.LoginResponse{
		Token: token,
		User: model.UserVO{
			ID:       user.ID,
			Phone:    user.Phone,
			Nickname: user.Nickname,
			Avatar:   user.Avatar,
		},
	}, nil
}

// Register 用户注册
func (s *AuthService) Register(req *model.RegisterRequest) error {
	// 检查手机号是否已存在
	existUser, _ := s.userRepo.FindByPhone(req.Phone)
	if existUser != nil {
		return errors.New("手机号已注册")
	}

	// 创建用户
	user := &model.Client{
		AdminsID:   req.AdminsID,
		Phone:      req.Phone,
		Nickname:   req.Nickname,
		Country:    "CN",
		DialCode:   "+86",
		AgreeTerms: req.AgreeTerms,
		PhoneBound: 0,
		EmailBound: 0,
		IsVendor:   0,
		Status:     1,
	}

	if err := s.userRepo.Create(user, req.Password); err != nil {
		logger.Error("创建用户失败", err, zap.String("phone", req.Phone))
		return errors.New("注册失败")
	}

	logger.Info("用户注册成功", zap.Int("user_id", user.ID), zap.String("phone", req.Phone))
	return nil
}
