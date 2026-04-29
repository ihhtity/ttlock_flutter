package middleware

import (
	"net/http"
	"sync"
	"time"
	"ttlock-backend/internal/config"
	"ttlock-backend/pkg/logger"
	"go.uber.org/zap"

	"github.com/gin-gonic/gin"
	"golang.org/x/time/rate"
)

// IPRateLimiter IP限流器
type IPRateLimiter struct {
	ips   map[string]*rate.Limiter
	mu    sync.RWMutex
	rps   float64
	burst int
}

// NewIPRateLimiter 创建IP限流器
func NewIPRateLimiter(rps float64, burst int) *IPRateLimiter {
	return &IPRateLimiter{
		ips:   make(map[string]*rate.Limiter),
		rps:   rps,
		burst: burst,
	}
}

// GetLimiter 获取或创建IP的限流器
func (i *IPRateLimiter) GetLimiter(ip string) *rate.Limiter {
	i.mu.Lock()
	defer i.mu.Unlock()

	limiter, exists := i.ips[ip]
	if !exists {
		limiter = rate.NewLimiter(rate.Limit(i.rps), i.burst)
		i.ips[ip] = limiter
	}

	return limiter
}

// Cleanup 定期清理不活跃的IP（可选）
func (i *IPRateLimiter) Cleanup() {
	i.mu.Lock()
	defer i.mu.Unlock()

	for ip, limiter := range i.ips {
		if limiter.Allow() {
			delete(i.ips, ip)
		}
	}
}

var globalLimiter *IPRateLimiter

// RateLimiter 限流中间件
func RateLimiter(cfg config.RateLimitConfig) gin.HandlerFunc {
	if !cfg.Enabled {
		return func(c *gin.Context) {
			c.Next()
		}
	}

	globalLimiter = NewIPRateLimiter(cfg.RequestsPerSecond, cfg.BurstSize)

	// 启动定期清理（每5分钟）
	go func() {
		ticker := time.NewTicker(5 * time.Minute)
		for range ticker.C {
			globalLimiter.Cleanup()
		}
	}()

	return func(c *gin.Context) {
		ip := c.ClientIP()
		limiter := globalLimiter.GetLimiter(ip)

		if !limiter.Allow() {
			logger.Warn("请求频率超限", zap.String("ip", ip))
			c.JSON(http.StatusTooManyRequests, gin.H{
				"code":    429,
				"message": "请求过于频繁，请稍后再试",
			})
			c.Abort()
			return
		}

		c.Next()
	}
}
