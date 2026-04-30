package model

import "time"

// VerificationCode 验证码模型
type VerificationCode struct {
	ID        int       `json:"id" db:"id"`
	Phone     *string   `json:"phone" db:"phone"`
	Email     *string   `json:"email" db:"email"`
	Code      string    `json:"code" db:"code"`
	Type      int       `json:"type" db:"type"` // 1-register, 2-reset password, 3-bind phone, 4-bind email
	Status    int       `json:"status" db:"status"` // 0-unused, 1-used, 2-expired
	ExpireAt  time.Time `json:"expire_at" db:"expire_at"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// SendVerificationCodeRequest 发送验证码请求
type SendVerificationCodeRequest struct {
	Phone string `json:"phone" binding:"required_without=Email"`
	Email string `json:"email" binding:"required_without=Phone"`
	Type  int    `json:"type" binding:"required,oneof=1 2 3 4"`
}

// VerifyCodeRequest 验证验证码请求
type VerifyCodeRequest struct {
	Phone string `json:"phone" binding:"required_without=Email"`
	Email string `json:"email" binding:"required_without=Phone"`
	Code  string `json:"code" binding:"required"`
	Type  int    `json:"type" binding:"required,oneof=1 2 3 4"`
}

// ResetPasswordRequest 重置密码请求
type ResetPasswordRequest struct {
	Phone       string `json:"phone"`
	Email       string `json:"email"`
	Code        string `json:"code" binding:"required"`
	NewPassword string `json:"new_password" binding:"required,min=6"`
}

// RetrievePasswordRequest 找回密码请求
type RetrievePasswordRequest struct {
	Phone string `json:"phone"`
	Email string `json:"email"`
	Code  string `json:"code" binding:"required"`
}
