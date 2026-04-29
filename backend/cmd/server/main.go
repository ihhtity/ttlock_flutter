package main

import (
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"ttlock-backend/internal/cache"
	"ttlock-backend/internal/config"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/router"
	"ttlock-backend/pkg/logger"
)

func main() {
	// 解析命令行参数
	configPath := "configs/config.yaml"
	if len(os.Args) > 1 {
		configPath = os.Args[1]
	}

	// 加载配置
	cfg, err := config.LoadConfig(configPath)
	if err != nil {
		log.Fatalf("加载配置失败: %v", err)
	}

	// 初始化日志
	if err := logger.Init(cfg.Log.Level, cfg.Log.Format); err != nil {
		log.Fatalf("初始化日志失败: %v", err)
	}

	logger.Info("应用启动中...")

	// 初始化数据库
	if err := database.Init(&cfg.Database); err != nil {
		logger.Fatal("初始化数据库失败", err)
	}
	defer database.Close()

	// 初始化 Redis 缓存
	if err := cache.Init(&cfg.Redis); err != nil {
		logger.Warn("初始化缓存失败", zap.Error(err))
	}
	defer cache.Close()

	// 设置 Gin 模式
	gin.SetMode(cfg.Server.Mode)

	// 创建路由
	r := router.SetupRouter(cfg)

	// 启动服务器
	addr := fmt.Sprintf(":%d", cfg.Server.Port)
	logger.Info(fmt.Sprintf("服务器启动在 %s", addr))

	if err := r.Run(addr); err != nil {
		logger.Fatal("服务器启动失败", err)
	}
}
