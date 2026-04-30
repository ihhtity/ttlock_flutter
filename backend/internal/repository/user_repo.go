package repository

import (
	"database/sql"
	"time"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/model"
)

// UserRepository 用户数据访问
type UserRepository struct{}

// NewUserRepository 创建用户仓库
func NewUserRepository() *UserRepository {
	return &UserRepository{}
}

// FindByPhone 根据手机号查找用户
func (r *UserRepository) FindByPhone(phone string) (*model.Client, error) {
	db := database.GetReadDB()
	
	query := `SELECT id, admins_id, phone, email, password, nickname, avatar, 
	                 country, dial_code, agree_terms, status, last_login, login_count, created, updated 
	          FROM clients WHERE phone = ?`
	
	var user model.Client
	err := db.QueryRow(query, phone).Scan(
		&user.ID, &user.AdminsID, &user.Phone, &user.Email, &user.Password,
		&user.Nickname, &user.Avatar, &user.Country, &user.DialCode,
		&user.AgreeTerms, &user.Status, &user.LastLogin, &user.LoginCount,
		&user.CreatedAt, &user.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	
	return &user, nil
}

// Create 创建用户
func (r *UserRepository) Create(user *model.Client, password string) error {
	db := database.GetWriteDB()
	
	// 明文存储密码（仅用于开发调试）
	now := time.Now()
	query := `INSERT INTO clients (admins_id, phone, email, password, nickname, country, dial_code, 
	                               agree_terms, status, created, updated) 
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
	
	result, err := db.Exec(query,
		user.AdminsID, user.Phone, user.Email, password, user.Nickname,
		user.Country, user.DialCode, user.AgreeTerms, user.Status, now, now,
	)
	
	if err != nil {
		return err
	}
	
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}
	
	user.ID = int(id)
	user.CreatedAt = now
	user.UpdatedAt = now
	
	return nil
}

// UpdateLastLogin 更新最后登录时间
func (r *UserRepository) UpdateLastLogin(userID int) error {
	db := database.GetWriteDB()
	
	now := time.Now()
	query := `UPDATE clients SET last_login = ?, login_count = login_count + 1, updated = ? WHERE id = ?`
	_, err := db.Exec(query, now, now, userID)
	
	return err
}

// VerifyPassword 验证密码（明文对比）
func (r *UserRepository) VerifyPassword(storedPassword, password string) bool {
	return storedPassword == password
}

// FindByEmail 根据邮箱查找用户
func (r *UserRepository) FindByEmail(email string) (*model.Client, error) {
	db := database.GetReadDB()
	
	query := `SELECT id, admins_id, phone, email, password, nickname, avatar, 
	                 country, dial_code, agree_terms, status, last_login, login_count, created, updated 
	          FROM clients WHERE email = ?`
	
	var user model.Client
	err := db.QueryRow(query, email).Scan(
		&user.ID, &user.AdminsID, &user.Phone, &user.Email, &user.Password,
		&user.Nickname, &user.Avatar, &user.Country, &user.DialCode,
		&user.AgreeTerms, &user.Status, &user.LastLogin, &user.LoginCount,
		&user.CreatedAt, &user.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	
	return &user, nil
}

// UpdatePassword 更新密码（明文存储）
func (r *UserRepository) UpdatePassword(userID int, newPassword string) error {
	db := database.GetWriteDB()
	
	// 明文存储密码（仅用于开发调试）
	now := time.Now()
	query := `UPDATE clients SET password = ?, updated = ? WHERE id = ?`
	_, err := db.Exec(query, newPassword, now, userID)
	
	return err
}

// UpdateCountry 更新国家/地区信息
func (r *UserRepository) UpdateCountry(userID int, country, dialCode *string) error {
	db := database.GetWriteDB()
	
	now := time.Now()
	query := `UPDATE clients SET country = ?, dial_code = ?, updated = ? WHERE id = ?`
	_, err := db.Exec(query, country, dialCode, now, userID)
	
	return err
}
