package repository

import (
	"database/sql"
	"errors"
	"time"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/model"
)

// VerificationCodeRepository 验证码数据访问
type VerificationCodeRepository struct{}

// NewVerificationCodeRepository 创建验证码仓库
func NewVerificationCodeRepository() *VerificationCodeRepository {
	return &VerificationCodeRepository{}
}

// Create 创建验证码记录
func (r *VerificationCodeRepository) Create(code *model.VerificationCode) error {
	db := database.GetWriteDB()

	query := `INSERT INTO verification_codes (phone, email, code, type, status, expire_at) 
	          VALUES (?, ?, ?, ?, ?, ?)`

	result, err := db.Exec(query, code.Phone, code.Email, code.Code, code.Type, code.Status, code.ExpireAt)
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	code.ID = int(id)
	return nil
}

// FindValidCode 查找有效的验证码
func (r *VerificationCodeRepository) FindValidCode(phone, email string, codeType int) (*model.VerificationCode, error) {
	db := database.GetReadDB()

	// 首先，将已过期的验证码标记为已过期
	r.ExpireExpiredCodes()

	var query string
	var args []interface{}

	if phone != "" {
		query = `SELECT id, phone, email, code, type, status, expire_at, created_at, updated_at 
		         FROM verification_codes 
		         WHERE phone = ? AND type = ? AND status = 0 AND expire_at > ?
		         ORDER BY created_at DESC LIMIT 1`
		args = []interface{}{phone, codeType, time.Now()}
	} else {
		query = `SELECT id, phone, email, code, type, status, expire_at, created_at, updated_at 
		         FROM verification_codes 
		         WHERE email = ? AND type = ? AND status = 0 AND expire_at > ?
		         ORDER BY created_at DESC LIMIT 1`
		args = []interface{}{email, codeType, time.Now()}
	}

	var vc model.VerificationCode
	err := db.QueryRow(query, args...).Scan(
		&vc.ID, &vc.Phone, &vc.Email, &vc.Code, &vc.Type,
		&vc.Status, &vc.ExpireAt, &vc.CreatedAt, &vc.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &vc, nil
}

// MarkAsUsed 标记验证码为已使用
func (r *VerificationCodeRepository) MarkAsUsed(codeID int) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `UPDATE verification_codes SET status = 1, updated_at = ? WHERE id = ?`
	_, err := db.Exec(query, now, codeID)

	return err
}

// ExpireOldCodes 过期旧的验证码（同一手机号/邮箱）
func (r *VerificationCodeRepository) ExpireOldCodes(phone, email string, codeType int) error {
	db := database.GetWriteDB()

	now := time.Now()
	var query string
	var args []interface{}

	if phone != "" {
		query = `UPDATE verification_codes SET status = 2, updated_at = ? 
		         WHERE phone = ? AND type = ? AND status = 0`
		args = []interface{}{now, phone, codeType}
	} else {
		query = `UPDATE verification_codes SET status = 2, updated_at = ? 
		         WHERE email = ? AND type = ? AND status = 0`
		args = []interface{}{now, email, codeType}
	}

	_, err := db.Exec(query, args...)
	return err
}

// ExpireExpiredCodes 将所有已过期的验证码标记为已过期
func (r *VerificationCodeRepository) ExpireExpiredCodes() error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `UPDATE verification_codes SET status = 2, updated_at = ? 
	         WHERE status = 0 AND expire_at <= ?`
	_, err := db.Exec(query, now, now)

	return err
}

// VerifyAndMarkAsUsed 验证验证码并标记为已使用
func (r *VerificationCodeRepository) VerifyAndMarkAsUsed(phone, email string, code string, codeType int) error {
	// 查找有效的验证码
	vc, err := r.FindValidCode(phone, email, codeType)
	if err != nil {
		return err
	}
	
	if vc == nil {
		return sql.ErrNoRows
	}
	
	// 验证验证码是否正确
	if vc.Code != code {
		return errors.New("验证码错误")
	}
	
	// 标记为已使用
	return r.MarkAsUsed(vc.ID)
}
