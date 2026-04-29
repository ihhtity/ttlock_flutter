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
	authService *service.AuthService
}

// NewAuthHandler 创建认证处理器
func NewAuthHandler() *AuthHandler {
	return &AuthHandler{
		authService: service.NewAuthService(),
	}
}

// Login 用户登录
func (h *AuthHandler) Login(c *gin.Context) {
	var req model.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	result, err := h.authService.Login(req.Phone, req.Password)
	if err != nil {
		logger.Warn("登录失败", zap.String("phone", req.Phone), zap.Error(err))
		response.Unauthorized(c, err.Error())
		return
	}

	logger.Info("用户登录成功", zap.Int("user_id", result.User.ID))
	response.Success(c, result)
}

// Register 用户注册
func (h *AuthHandler) Register(c *gin.Context) {
	var req model.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	if err := h.authService.Register(&req); err != nil {
		logger.Warn("注册失败", zap.String("phone", req.Phone), zap.Error(err))
		response.BadRequest(c, err.Error())
		return
	}

	logger.Info("用户注册成功", zap.String("phone", req.Phone))
	response.SuccessWithMessage(c, "注册成功", nil)
}
