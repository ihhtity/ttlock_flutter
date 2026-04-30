package router

import (
	"net/http"
	"time"
	"ttlock-backend/internal/cache"
	"ttlock-backend/internal/config"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/handler"
	"ttlock-backend/internal/middleware"
	"ttlock-backend/pkg/jwt"

	"github.com/gin-gonic/gin"
)

// SetupRouter 配置路由
func SetupRouter(cfg *config.Config) *gin.Engine {
	r := gin.New()

	// 初始化 JWT
	jwt.Init(cfg.JWT.Secret)

	// 全局中间件
	r.Use(middleware.Logger())
	r.Use(middleware.Recovery())
	r.Use(middleware.CORS(cfg.CORS))
	r.Use(middleware.RateLimiter(cfg.RateLimit))

	// 健康检查
	r.GET("/health", func(c *gin.Context) {
		status := gin.H{
			"status":    "ok",
			"timestamp": time.Now().Format("2006-01-02 15:04:05"),
		}

		// 检查数据库连接
		if database.GetWriteDB().Ping() == nil {
			status["database"] = "connected"
		} else {
			status["database"] = "disconnected"
			status["status"] = "degraded"
		}

		// 检查 Redis 连接
		if cache.Exists("health:check") {
			status["redis"] = "connected"
		} else {
			// 尝试写入测试数据
			if err := cache.Set("health:check", "ok", 10*time.Second); err == nil {
				status["redis"] = "connected"
			} else {
				status["redis"] = "disconnected"
				status["status"] = "degraded"
			}
		}

		c.JSON(http.StatusOK, status)
	})

	// API v1
	v1 := r.Group("/api/v1")
	{
		// 公开接口（无需认证）
		auth := v1.Group("/auth")
		{
			authHandler := handler.NewAuthHandler()
			auth.POST("/login", authHandler.Login)
			auth.POST("/register", authHandler.Register)
			auth.POST("/send-code", authHandler.SendVerificationCode)
			auth.POST("/verify-code", authHandler.VerifyCode)
			auth.POST("/reset-password", authHandler.ResetPassword)
			auth.POST("/retrieve-password", authHandler.RetrievePassword)
		}

		// 需要认证的接口
		authorized := v1.Group("")
		authorized.Use(middleware.Auth())
		{
			// 设备路由
			deviceHandler := handler.NewDeviceHandler()
			authorized.GET("/devices", deviceHandler.List)
			authorized.GET("/devices/:id", deviceHandler.GetDetail)
			authorized.POST("/devices", deviceHandler.Create)
			authorized.PUT("/devices/:id", deviceHandler.Update)
			authorized.DELETE("/devices/:id", deviceHandler.Delete)

			// 房间路由
			roomHandler := handler.NewRoomHandler()
			authorized.GET("/rooms", roomHandler.List)
			authorized.GET("/rooms/:id", roomHandler.GetDetail)
			authorized.POST("/rooms", roomHandler.Create)
			authorized.PUT("/rooms/:id", roomHandler.Update)
			authorized.DELETE("/rooms/:id", roomHandler.Delete)

			// 分组路由
			groupHandler := handler.NewGroupHandler()
			authorized.GET("/groups", groupHandler.List)
			authorized.GET("/groups/:id", groupHandler.GetDetail)
			authorized.POST("/groups", groupHandler.Create)
			authorized.PUT("/groups/:id", groupHandler.Update)
			authorized.DELETE("/groups/:id", groupHandler.Delete)
		}
	}

	return r
}
