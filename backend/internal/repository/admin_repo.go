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
