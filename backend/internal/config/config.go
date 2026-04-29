package config

import (
	"fmt"
	"github.com/spf13/viper"
)

// Config 应用配置结构
type Config struct {
	Server   ServerConfig   `mapstructure:"server"`
	Database DatabaseConfig `mapstructure:"database"`
	Redis    RedisConfig    `mapstructure:"redis"`
	Cache    CacheConfig    `mapstructure:"cache"`
	JWT      JWTConfig      `mapstructure:"jwt"`
	Log      LogConfig      `mapstructure:"log"`
	CORS     CORSConfig     `mapstructure:"cors"`
	RateLimit RateLimitConfig `mapstructure:"rate_limit"`
}

// ServerConfig 服务器配置
type ServerConfig struct {
	Port int    `mapstructure:"port"`
	Mode string `mapstructure:"mode"`
}

// DatabaseConfig 数据库配置
type DatabaseConfig struct {
	MasterDSN      string   `mapstructure:"master_dsn"`
	SlaveDSNs      []string `mapstructure:"slave_dsns"`
	MaxOpenConns   int      `mapstructure:"max_open_conns"`
	MaxIdleConns   int      `mapstructure:"max_idle_conns"`
	ConnMaxLifetime int     `mapstructure:"conn_max_lifetime"`
	ConnMaxIdleTime int     `mapstructure:"conn_max_idle_time"`
}

// RedisConfig Redis配置
type RedisConfig struct {
	Enabled  bool   `mapstructure:"enabled"`
	Host     string `mapstructure:"host"`
	Port     int    `mapstructure:"port"`
	Password string `mapstructure:"password"`
	DB       int    `mapstructure:"db"`
	PoolSize int    `mapstructure:"pool_size"`
}

// CacheConfig 缓存配置
type CacheConfig struct {
	LocalTTL     int  `mapstructure:"local_ttl"`
	RedisTTL     int  `mapstructure:"redis_ttl"`
	WarmupEnabled bool `mapstructure:"warmup_enabled"`
}

// JWTConfig JWT配置
type JWTConfig struct {
	Secret      string `mapstructure:"secret"`
	ExpireHours int    `mapstructure:"expire_hours"`
}

// LogConfig 日志配置
type LogConfig struct {
	Level    string `mapstructure:"level"`
	Format   string `mapstructure:"format"`
	Output   string `mapstructure:"output"`
	FilePath string `mapstructure:"file_path"`
}

// CORSConfig CORS配置
type CORSConfig struct {
	AllowedOrigins  []string `mapstructure:"allowed_origins"`
	AllowedMethods  []string `mapstructure:"allowed_methods"`
	AllowedHeaders  []string `mapstructure:"allowed_headers"`
	AllowCredentials bool    `mapstructure:"allow_credentials"`
}

// RateLimitConfig 限流配置
type RateLimitConfig struct {
	Enabled          bool    `mapstructure:"enabled"`
	RequestsPerSecond float64 `mapstructure:"requests_per_second"`
	BurstSize        int     `mapstructure:"burst_size"`
}

var GlobalConfig *Config

// LoadConfig 加载配置文件
func LoadConfig(path string) (*Config, error) {
	viper.SetConfigFile(path)
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		return nil, fmt.Errorf("读取配置文件失败: %w", err)
	}

	var config Config
	if err := viper.Unmarshal(&config); err != nil {
		return nil, fmt.Errorf("解析配置文件失败: %w", err)
	}

	GlobalConfig = &config
	return &config, nil
}
