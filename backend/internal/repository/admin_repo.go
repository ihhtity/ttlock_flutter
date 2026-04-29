package repository

import (
	"database/sql"
	"time"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/model"
	"golang.org/x/crypto/bcrypt"
)

// AdminRepository 管理员数据访问
type AdminRepository struct{}

// NewAdminRepository 创建管理员仓库
func NewAdminRepository() *AdminRepository {
	return &AdminRepository{}
}

// FindByUsername 根据用户名查找管理员
func (r *AdminRepository) FindByUsername(username string) (*model.Admin, error) {
	db := database.GetReadDB()
	
	query := `SELECT id, username, password, real_name, phone, email, avatar, 
	                 role, permissions, status, agree_terms, last_login, login_count, created, updated 
	          FROM admins WHERE username = ?`
	
	var admin model.Admin
	err := db.QueryRow(query, username).Scan(
		&admin.ID, &admin.Username, &admin.Password,
		&admin.RealName, &admin.Phone, &admin.Email, &admin.Avatar,
		&admin.Role, &admin.Permissions, &admin.Status, &admin.AgreeTerms,
		&admin.LastLogin, &admin.LoginCount,
		&admin.CreatedAt, &admin.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	
	return &admin, nil
}

// UpdateLastLogin 更新最后登录时间
func (r *AdminRepository) UpdateLastLogin(adminID int) error {
	db := database.GetWriteDB()
	
	now := time.Now()
	query := `UPDATE admins SET last_login = ?, login_count = login_count + 1, updated = ? WHERE id = ?`
	_, err := db.Exec(query, now, now, adminID)
	
	return err
}

// VerifyPassword 验证密码
func (r *AdminRepository) VerifyPassword(hashedPassword, password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
	return err == nil
}

// FindByPhone 根据手机号查找管理员
func (r *AdminRepository) FindByPhone(phone string) (*model.Admin, error) {
	db := database.GetReadDB()
	
	query := `SELECT id, username, password, real_name, phone, email, avatar, 
	                 role, permissions, status, agree_terms, last_login, login_count, created, updated 
	          FROM admins WHERE phone = ?`
	
	var admin model.Admin
	err := db.QueryRow(query, phone).Scan(
		&admin.ID, &admin.Username, &admin.Password,
		&admin.RealName, &admin.Phone, &admin.Email, &admin.Avatar,
		&admin.Role, &admin.Permissions, &admin.Status, &admin.AgreeTerms,
		&admin.LastLogin, &admin.LoginCount,
		&admin.CreatedAt, &admin.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	
	return &admin, nil
}

// FindByEmail 根据邮箱查找管理员
func (r *AdminRepository) FindByEmail(email string) (*model.Admin, error) {
	db := database.GetReadDB()
	
	query := `SELECT id, username, password, real_name, phone, email, avatar, 
	                 role, permissions, status, agree_terms, last_login, login_count, created, updated 
	          FROM admins WHERE email = ?`
	
	var admin model.Admin
	err := db.QueryRow(query, email).Scan(
		&admin.ID, &admin.Username, &admin.Password,
		&admin.RealName, &admin.Phone, &admin.Email, &admin.Avatar,
		&admin.Role, &admin.Permissions, &admin.Status, &admin.AgreeTerms,
		&admin.LastLogin, &admin.LoginCount,
		&admin.CreatedAt, &admin.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	
	return &admin, nil
}

// Create 创建管理员
func (r *AdminRepository) Create(admin *model.Admin, password string) error {
	db := database.GetWriteDB()
	
	// 加密密码
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	
	now := time.Now()
	query := `INSERT INTO admins (username, password, real_name, phone, email, status, agree_terms, created, updated) 
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
	
	result, err := db.Exec(query, 
		admin.Username, string(hashedPassword), admin.RealName,
		admin.Phone, admin.Email, admin.Status, admin.AgreeTerms,
		now, now)
	
	if err != nil {
		return err
	}
	
	id, err := result.LastInsertId()
	if err == nil {
		admin.ID = int(id)
	}
	
	return err
}
