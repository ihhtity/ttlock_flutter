package database

import (
	"database/sql"
	"fmt"
	"log"
	"math/rand"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"ttlock-backend/internal/config"
)

var (
	MasterDB *sql.DB
	SlaveDBs []*sql.DB
)

// Init 初始化数据库连接
func Init(cfg *config.DatabaseConfig) error {
	var err error

	// 初始化主库
	MasterDB, err = createConnectionPool(cfg.MasterDSN, cfg)
	if err != nil {
		return fmt.Errorf("初始化主库失败: %w", err)
	}

	// 初始化从库
	for _, dsn := range cfg.SlaveDSNs {
		slave, err := createConnectionPool(dsn, cfg)
		if err != nil {
			log.Printf("警告: 初始化从库失败: %v", err)
			continue
		}
		SlaveDBs = append(SlaveDBs, slave)
	}

	log.Printf("数据库初始化完成 - 主库: 1, 从库: %d", len(SlaveDBs))
	return nil
}

// createConnectionPool 创建数据库连接池
func createConnectionPool(dsn string, cfg *config.DatabaseConfig) (*sql.DB, error) {
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}

	// 配置连接池
	db.SetMaxOpenConns(cfg.MaxOpenConns)
	db.SetMaxIdleConns(cfg.MaxIdleConns)
	db.SetConnMaxLifetime(time.Duration(cfg.ConnMaxLifetime) * time.Second)
	db.SetConnMaxIdleTime(time.Duration(cfg.ConnMaxIdleTime) * time.Second)

	// 测试连接
	if err := db.Ping(); err != nil {
		return nil, err
	}

// 	log.Println("数据库连接成功")
	return db, nil
}

// GetReadDB 获取读数据库（负载均衡）
func GetReadDB() *sql.DB {
	if len(SlaveDBs) == 0 {
		return MasterDB
	}
	return SlaveDBs[rand.Intn(len(SlaveDBs))]
}

// GetWriteDB 获取写数据库
func GetWriteDB() *sql.DB {
	return MasterDB
}

// Close 关闭所有数据库连接
func Close() {
	if MasterDB != nil {
		MasterDB.Close()
	}
	for _, slave := range SlaveDBs {
		if slave != nil {
			slave.Close()
		}
	}
}
