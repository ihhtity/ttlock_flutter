package handler

import (
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/service"
	"ttlock-backend/pkg/logger"
	"ttlock-backend/pkg/response"
	"go.uber.org/zap"

	"github.com/gin-gonic/gin"
)

// AuthHandler 认证处理器
type AuthHandler struct {
	authService        *service.AuthService
	verificationService *service.VerificationService
}

// NewAuthHandler 创建认证处理器
func NewAuthHandler() *AuthHandler {
	return &AuthHandler{
		authService:        service.NewAuthService(),
		verificationService: service.NewVerificationService(),
	}
}

// Login 用户登录
func (h *AuthHandler) Login(c *gin.Context) {
	var req model.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		logger.Warn("登录参数错误", zap.Error(err))
		response.BadRequest(c, "请求参数错误，请检查输入")
		return
	}

	// 提取手机号和邮箱
	phone := ""
	if req.Phone != nil {
		phone = *req.Phone
	}
	email := ""
	if req.Email != nil {
		email = *req.Email
	}

	logger.Info("收到登录请求", 
		zap.String("phone", phone), 
		zap.String("email", email))

	result, err := h.authService.Login(phone, email, req.Password)
	if err != nil {
		logger.Warn("登录失败",
			zap.String("reason", err.Error()),
			zap.String("phone", phone),
			zap.String("email", email))
		response.Unauthorized(c, err.Error())
		return
	}

	logger.Info("用户登录成功", 
		zap.Int("user_id", result.User.ID),
		zap.String("nickname", *result.User.Nickname),
		zap.String("phone", phone),
		zap.String("email", email))
	response.Success(c, result)
}

// Register 用户注册
func (h *AuthHandler) Register(c *gin.Context) {
	var req model.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		logger.Warn("注册参数错误", zap.Error(err))
		response.BadRequest(c, "请求参数错误，请检查输入")
		return
	}

	phone := ""
	if req.Phone != nil {
		phone = *req.Phone
	}
	email := ""
	if req.Email != nil {
		email = *req.Email
	}

	logger.Info("收到注册请求",
		zap.String("phone", phone),
		zap.String("email", email),
		zap.String("nickname", req.Nickname),
		zap.Int("register_type", req.RegisterType))

	if err := h.authService.Register(&req); err != nil {
		logger.Warn("注册失败",
			zap.String("reason", err.Error()),
			zap.String("phone", phone),
			zap.String("email", email))
		response.BadRequest(c, err.Error())
		return
	}

	logger.Info("用户注册成功",
		zap.String("phone", phone),
		zap.String("email", email),
		zap.String("nickname", req.Nickname))
	response.SuccessWithMessage(c, "注册成功", nil)
}

// SendVerificationCode 发送验证码
func (h *AuthHandler) SendVerificationCode(c *gin.Context) {
	var req model.SendVerificationCodeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		logger.Warn("发送验证码参数错误", zap.Error(err))
		response.BadRequest(c, "请求参数错误，请检查输入")
		return
	}

	phone := req.Phone
	email := req.Email

	logger.Info("收到发送验证码请求",
		zap.String("phone", phone),
		zap.String("email", email),
		zap.Int("type", req.Type))

	if err := h.verificationService.SendCode(phone, email, req.Type); err != nil {
		logger.Warn("发送验证码失败",
			zap.String("reason", err.Error()),
			zap.String("phone", phone),
			zap.String("email", email),
			zap.Int("type", req.Type))
		response.BadRequest(c, err.Error())
		return
	}

	logger.Info("验证码发送成功",
		zap.String("phone", phone),
		zap.String("email", email),
		zap.Int("type", req.Type))
	response.SuccessWithMessage(c, "验证码已发送", nil)
}

// VerifyCode 验证验证码
func (h *AuthHandler) VerifyCode(c *gin.Context) {
	var req model.VerifyCodeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		logger.Warn("验证验证码参数错误", zap.Error(err))
		response.BadRequest(c, "请求参数错误，请检查输入")
		return
	}

	phone := req.Phone
	email := req.Email

	logger.Info("收到验证验证码请求",
		zap.String("phone", phone),
		zap.String("email", email),
		zap.String("code", req.Code),
		zap.Int("type", req.Type))

	if err := h.verificationService.VerifyCode(phone, email, req.Code, req.Type); err != nil {
		logger.Warn("验证验证码失败",
			zap.String("reason", err.Error()),
			zap.String("phone", phone),
			zap.String("email", email),
			zap.String("code", req.Code),
			zap.Int("type", req.Type))
		response.BadRequest(c, err.Error())
		return
	}

	logger.Info("验证码验证成功",
		zap.String("phone", phone),
		zap.String("email", email),
		zap.Int("type", req.Type))
	response.SuccessWithMessage(c, "验证成功", nil)
}

// ResetPassword 重置密码
func (h *AuthHandler) ResetPassword(c *gin.Context) {
	var req model.ResetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		logger.Warn("重置密码参数错误", zap.Error(err))
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	phone := req.Phone
	email := req.Email

	// 手动验证 phone 或 email 至少有一个不为空
	if phone == "" && email == "" {
		logger.Warn("重置密码参数错误: phone和email不能同时为空")
		response.BadRequest(c, "手机号或邮箱不能同时为空")
		return
	}

	logger.Info("收到重置密码请求",
		zap.String("phone", phone),
		zap.String("email", email))

	if err := h.verificationService.ResetPassword(phone, email, req.Code, req.NewPassword); err != nil {
		logger.Warn("重置密码失败",
			zap.String("reason", err.Error()),
			zap.String("phone", phone),
			zap.String("email", email))
		response.BadRequest(c, err.Error())
		return
	}

	logger.Info("密码重置成功",
		zap.String("phone", phone),
		zap.String("email", email))
	response.SuccessWithMessage(c, "密码重置成功", nil)
}

// RetrievePassword 找回密码（返回明文密码）
func (h *AuthHandler) RetrievePassword(c *gin.Context) {
	var req model.RetrievePasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		logger.Warn("找回密码参数错误", zap.Error(err))
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	phone := req.Phone
	email := req.Email

	// 手动验证 phone 或 email 至少有一个不为空
	if phone == "" && email == "" {
		logger.Warn("找回密码参数错误: phone和email不能同时为空")
		response.BadRequest(c, "手机号或邮箱不能同时为空")
		return
	}

	logger.Info("收到找回密码请求",
		zap.String("phone", phone),
		zap.String("email", email))

	password, err := h.verificationService.RetrievePassword(phone, email, req.Code)
	if err != nil {
		logger.Warn("找回密码失败",
			zap.String("reason", err.Error()),
			zap.String("phone", phone),
			zap.String("email", email))
		response.BadRequest(c, err.Error())
		return
	}

	logger.Info("密码找回成功",
		zap.String("phone", phone),
		zap.String("email", email))
	
	// 返回明文密码
	response.Success(c, gin.H{
		"password": password,
	})
}
