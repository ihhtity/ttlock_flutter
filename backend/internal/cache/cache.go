package cache

import (
	"context"
	"encoding/json"
	"fmt"
	"time"
	"ttlock-backend/internal/config"
	"ttlock-backend/pkg/logger"
	"go.uber.org/zap"

	"github.com/go-redis/redis/v8"
	"github.com/dgraph-io/ristretto"
)

var (
	ctx = context.Background()
	rdb *redis.Client
	lc  *ristretto.Cache
	cfg *config.RedisConfig
)

// Init 初始化缓存系统
func Init(c *config.RedisConfig) error {
	cfg = c

	if !c.Enabled {
		logger.Info("缓存系统已禁用")
		return nil
	}

	// 初始化 Redis
	rdb = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", c.Host, c.Port),
		Password: c.Password,
		DB:       c.DB,
		PoolSize: c.PoolSize,
	})

	// 测试连接
	if err := rdb.Ping(ctx).Err(); err != nil {
		logger.Warn("Redis连接失败，将仅使用本地缓存", zap.Error(err))
		rdb = nil
	} else {
		logger.Info("Redis连接成功")
	}

	// 初始化本地缓存（Ristretto）
	var err error
	lc, err = ristretto.NewCache(&ristretto.Config{
		NumCounters: 1e7,     // 计数器数量
		MaxCost:     1 << 30, // 最大成本（1GB）
		BufferItems: 64,      // 缓冲区大小
	})
	if err != nil {
		return err
	}

	logger.Info("本地缓存初始化成功")
	return nil
}

// Close 关闭缓存连接
func Close() {
	if lc != nil {
		lc.Close()
	}
	if rdb != nil {
		rdb.Close()
	}
}

// Get 获取缓存（先查本地缓存，再查Redis）
func Get(key string) (interface{}, bool) {
	// 1. 先查本地缓存
	if lc != nil {
		if value, found := lc.Get(key); found {
			return value, true
		}
	}

	// 2. 再查 Redis
	if rdb != nil {
		data, err := rdb.Get(ctx, key).Bytes()
		if err == nil {
			var value interface{}
			if err := json.Unmarshal(data, &value); err == nil {
				// 写入本地缓存
				if lc != nil {
					lc.SetWithTTL(key, value, 1, 30*time.Second)
				}
				return value, true
			}
		}
	}

	return nil, false
}

// Set 设置缓存（同时写入本地缓存和Redis）
func Set(key string, value interface{}, ttl time.Duration) error {
	data, err := json.Marshal(value)
	if err != nil {
		return err
	}

	// 写入本地缓存
	if lc != nil {
		lc.SetWithTTL(key, value, 1, 30*time.Second)
	}

	// 写入 Redis
	if rdb != nil {
		return rdb.Set(ctx, key, data, ttl).Err()
	}

	return nil
}

// Delete 删除缓存
func Delete(key string) error {
	// 删除本地缓存
	if lc != nil {
		lc.Del(key)
	}

	// 删除 Redis
	if rdb != nil {
		return rdb.Del(ctx, key).Err()
	}

	return nil
}

// DeletePattern 批量删除（支持通配符）
func DeletePattern(pattern string) error {
	if rdb == nil {
		return nil
	}

	var cursor uint64
	for {
		keys, nextCursor, err := rdb.Scan(ctx, cursor, pattern, 100).Result()
		if err != nil {
			return err
		}

		if len(keys) > 0 {
			rdb.Del(ctx, keys...)
		}

		cursor = nextCursor
		if cursor == 0 {
			break
		}
	}

	return nil
}

// Exists 检查键是否存在
func Exists(key string) bool {
	if rdb != nil {
		n, _ := rdb.Exists(ctx, key).Result()
		return n > 0
	}
	return false
}

// GetDevice 获取设备缓存
func GetDevice(deviceID int) (interface{}, bool) {
	key := fmt.Sprintf("device:%d", deviceID)
	return Get(key)
}

// SetDevice 设置设备缓存
func SetDevice(deviceID int, device interface{}) error {
	key := fmt.Sprintf("device:%d", deviceID)
	return Set(key, device, 5*time.Minute)
}

// InvalidateDevice 清除设备缓存
func InvalidateDevice(deviceID int) error {
	key := fmt.Sprintf("device:%d", deviceID)
	return Delete(key)
}

// GetDevicesList 获取设备列表缓存
func GetDevicesList(adminsID, clientID int, page, pageSize int) (interface{}, bool) {
	key := fmt.Sprintf("devices:list:%d:%d:%d:%d", adminsID, clientID, page, pageSize)
	return Get(key)
}

// SetDevicesList 设置设备列表缓存
func SetDevicesList(adminsID, clientID, page, pageSize int, data interface{}) error {
	key := fmt.Sprintf("devices:list:%d:%d:%d:%d", adminsID, clientID, page, pageSize)
	return Set(key, data, 2*time.Minute)
}

// InvalidateDevicesList 清除设备列表缓存
func InvalidateDevicesList(adminsID, clientID int) error {
	pattern := fmt.Sprintf("devices:list:%d:%d:*", adminsID, clientID)
	return DeletePattern(pattern)
}

// GetUser 获取用户缓存
func GetUser(userID int) (interface{}, bool) {
	key := fmt.Sprintf("user:%d", userID)
	return Get(key)
}

// SetUser 设置用户缓存
func SetUser(userID int, user interface{}) error {
	key := fmt.Sprintf("user:%d", userID)
	return Set(key, user, 30*time.Minute)
}

// InvalidateUser 清除用户缓存
func InvalidateUser(userID int) error {
	key := fmt.Sprintf("user:%d", userID)
	return Delete(key)
}
