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
	adminRepo *repository.AdminRepository
	verificationRepo *repository.VerificationCodeRepository
}

// NewAuthService 创建认证服务
func NewAuthService() *AuthService {
	return &AuthService{
		userRepo: repository.NewUserRepository(),
		adminRepo: repository.NewAdminRepository(),
		verificationRepo: repository.NewVerificationCodeRepository(),
	}
}

// Login 用户登录（支持管理端和客户端）
func (s *AuthService) Login(phone, email, password string) (*model.LoginResponse, error) {
	// 先尝试查找管理员
	if phone != "" {
		admin, err := s.adminRepo.FindByUsername(phone)
		if err != nil {
			logger.Error("查询管理员失败", err, zap.String("username", phone))
			return nil, errors.New("服务器错误")
		}

		if admin != nil {
			// 管理员登录
			return s.loginAdmin(admin, password)
		}
	}

	// 如果不是管理员，尝试查找客户端用户
	var user *model.Client
	var err error
	
	if phone != "" {
		user, err = s.userRepo.FindByPhone(phone)
	} else if email != "" {
		user, err = s.userRepo.FindByEmail(email)
	}
	
	if err != nil {
		logger.Error("查询用户失败", err)
		return nil, errors.New("服务器错误!")
	}

	if user == nil {
		return nil, errors.New("用户不存在")
	}

	// 客户端用户登录
	return s.loginClient(user, password)
}

// loginAdmin 管理员登录
func (s *AuthService) loginAdmin(admin *model.Admin, password string) (*model.LoginResponse, error) {
	// 检查管理员状态
	if admin.Status != 1 {
		return nil, errors.New("账号已被禁用")
	}

	// 检查是否同意用户协议和隐私政策
	if admin.AgreeTerms != 1 {
		return nil, errors.New("请先同意用户协议和隐私政策")
	}

	// 验证密码
	if !s.adminRepo.VerifyPassword(admin.Password, password) {
		return nil, errors.New("密码错误")
	}

	// 生成 Token (role=1表示管理员)
	token, err := jwt.GenerateToken(admin.ID, 0, admin.Role, 24)
	if err != nil {
		logger.Error("生成Token失败", err)
		return nil, errors.New("服务器错误")
	}

	// 更新最后登录时间
	s.adminRepo.UpdateLastLogin(admin.ID)

	// 返回响应
	return &model.LoginResponse{
		Token: token,
		User: model.UserVO{
			ID:       admin.ID,
			Phone:    admin.Phone,
			Email:    admin.Email,
			Nickname: admin.RealName,
			Avatar:   admin.Avatar,
			Role:     admin.Role,
		},
	}, nil
}

// loginClient 客户端用户登录
func (s *AuthService) loginClient(user *model.Client, password string) (*model.LoginResponse, error) {
	// 检查用户状态
	if user.Status != 1 {
		return nil, errors.New("账号已被禁用")
	}

	// 验证密码
	if !s.userRepo.VerifyPassword(user.Password, password) {
		return nil, errors.New("密码错误")
	}

	// 生成 Token (role=0表示客户端用户)
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
			Email:    user.Email,
			Nickname: user.Nickname,
			Avatar:   user.Avatar,
		},
	}, nil
}

// Register 用户注册（支持管理端和用户端）
func (s *AuthService) Register(req *model.RegisterRequest) error {
	// 检查手机号和邮箱是否都不提供
	if (req.Phone == nil || *req.Phone == "") && (req.Email == nil || *req.Email == "") {
		return errors.New("手机号或邮箱必须提供一个")
	}
	
	// 根据注册类型进行不同的处理
	if req.RegisterType == 1 {
		// 管理端注册 - 写入 admins 表
		return s.registerAdmin(req)
	} else {
		// 用户端注册 - 写入 clients 表（默认）
		return s.registerClient(req)
	}
}

// registerAdmin 管理端注册
func (s *AuthService) registerAdmin(req *model.RegisterRequest) error {
	// 检查手机号或邮箱是否已存在
	if req.Phone != nil && *req.Phone != "" {
		existAdmin, _ := s.adminRepo.FindByPhone(*req.Phone)
		if existAdmin != nil {
			return errors.New("手机号已注册")
		}
	}
	
	if req.Email != nil && *req.Email != "" {
		existAdmin, _ := s.adminRepo.FindByEmail(*req.Email)
		if existAdmin != nil {
			return errors.New("邮箱已注册")
		}
	}
	
	// 用户名使用手机号或邮箱
	username := ""
	if req.Phone != nil && *req.Phone != "" {
		username = *req.Phone
	} else if req.Email != nil && *req.Email != "" {
		username = *req.Email
	}
	
	// 创建管理员
	realName := req.Nickname
	admin := &model.Admin{
		Username:   username,
		Email:      req.Email,
		Phone:      req.Phone,
		RealName:   &realName,
		AgreeTerms: req.AgreeTerms,
		Status:     1,
	}
	
	if err := s.adminRepo.Create(admin, req.Password); err != nil {
		logger.Error("创建管理员失败", err)
		return errors.New("注册失败")
	}
	
	logger.Info("管理员注册成功", zap.String("username", username))
	return nil
}

// registerClient 用户端注册
func (s *AuthService) registerClient(req *model.RegisterRequest) error {
	// 检查手机号和邮箱是否都不提供
	if (req.Phone == nil || *req.Phone == "") && (req.Email == nil || *req.Email == "") {
		return errors.New("手机号或邮箱必须提供一个")
	}
	
	// 根据注册方式检查是否已存在
	if req.Phone != nil && *req.Phone != "" {
		existUser, _ := s.userRepo.FindByPhone(*req.Phone)
		if existUser != nil {
			return errors.New("手机号已注册")
		}
	}
	
	if req.Email != nil && *req.Email != "" {
		existUser, _ := s.userRepo.FindByEmail(*req.Email)
		if existUser != nil {
			return errors.New("邮箱已注册")
		}
	}

	// 处理默认值 - 用户名就是注册时使用的手机号或邮箱
	nickname := req.Nickname
	if nickname == "" {
		if req.Phone != nil && *req.Phone != "" {
			nickname = *req.Phone
		} else if req.Email != nil && *req.Email != "" {
			nickname = *req.Email
		}
	}
	
	country := "CN"
	if req.Country != "" {
		country = req.Country
	}
	
	dialCode := "+86"
	if req.DialCode != "" {
		dialCode = req.DialCode
	}
	
	phoneBound := 0
	if req.Phone != nil && *req.Phone != "" {
		phoneBound = 1
	}
	
	emailBound := 0
	if req.Email != nil && *req.Email != "" {
		emailBound = 1
	}
	
	// 创建用户
	user := &model.Client{
		AdminsID:   req.AdminsID,
		Phone:      req.Phone,
		Email:      req.Email,
		Nickname:   &nickname,
		Country:    &country,
		DialCode:   &dialCode,
		AgreeTerms: req.AgreeTerms,
		PhoneBound: phoneBound,
		EmailBound: emailBound,
		IsVendor:   0,
		Status:     1,
	}

	if err := s.userRepo.Create(user, req.Password); err != nil {
		logger.Error("创建用户失败", err)
		return errors.New("注册失败")
	}

	// 注册成功后，标记验证码为已使用（type=1表示注册）
	phoneStr := ""
	if req.Phone != nil {
		phoneStr = *req.Phone
	}
	emailStr := ""
	if req.Email != nil {
		emailStr = *req.Email
	}
	
	logger.Info("准备标记验证码为已使用", 
		zap.String("phone", phoneStr),
		zap.String("email", emailStr),
		zap.Int("type", 1))
	
	verificationCode, err := s.verificationRepo.FindValidCode(phoneStr, emailStr, 1)
	if err != nil {
		logger.Warn("查找验证码失败", zap.Error(err))
	} else if verificationCode == nil {
		logger.Warn("未找到有效的验证码，可能已被使用或过期",
			zap.String("phone", phoneStr),
			zap.String("email", emailStr))
	} else {
		if markErr := s.verificationRepo.MarkAsUsed(verificationCode.ID); markErr != nil {
			logger.Warn("标记验证码为已使用失败", zap.Error(markErr))
			// 不影响注册成功，只记录警告
		} else {
			logger.Info("✅ 验证码已标记为已使用", 
				zap.Int("code_id", verificationCode.ID),
				zap.String("code", verificationCode.Code))
		}
	}

	logger.Info("用户注册成功", zap.Int("user_id", user.ID))
	return nil
}
