package model

import "time"

// Admin 管理员模型
type Admin struct {
	ID         int       `json:"id" db:"id"`
	Username   string    `json:"username" db:"username"`
	RealName   string    `json:"real_name" db:"real_name"`
	Phone      string    `json:"phone" db:"phone"`
	Email      string    `json:"email" db:"email"`
	Avatar     string    `json:"avatar" db:"avatar"`
	Role       int       `json:"role" db:"role"`
	Permissions string   `json:"permissions" db:"permissions"`
	Status     int       `json:"status" db:"status"`
	LastLogin  time.Time `json:"last_login" db:"last_login"`
	LoginCount int       `json:"login_count" db:"login_count"`
	CreatedAt  time.Time `json:"created_at" db:"created"`
	UpdatedAt  time.Time `json:"updated_at" db:"updated"`
}

// Client 用户端用户模型
type Client struct {
	ID          int       `json:"id" db:"id"`
	AdminsID    int       `json:"admins_id" db:"admins_id"`
	Phone       string    `json:"phone" db:"phone"`
	Email       string    `json:"email" db:"email"`
	Password    string    `json:"-" db:"password"` // 密码不返回给前端
	Nickname    string    `json:"nickname" db:"nickname"`
	Avatar      string    `json:"avatar" db:"avatar"`
	Country     string    `json:"country" db:"country"`
	DialCode    string    `json:"dial_code" db:"dial_code"`
	AgreeTerms  int       `json:"agree_terms" db:"agree_terms"`
	PhoneBound  int       `json:"phone_bound" db:"phone_bound"`
	EmailBound  int       `json:"email_bound" db:"email_bound"`
	IsVendor    int       `json:"is_vendor" db:"is_vendor"`
	Status      int       `json:"status" db:"status"`
	LastLogin   time.Time `json:"last_login" db:"last_login"`
	LoginCount  int       `json:"login_count" db:"login_count"`
	CreatedAt   time.Time `json:"created_at" db:"created"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated"`
}

// LoginRequest 登录请求
type LoginRequest struct {
	Phone    string `json:"phone" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// RegisterRequest 注册请求
type RegisterRequest struct {
	Phone      string `json:"phone" binding:"required"`
	Password   string `json:"password" binding:"required,min=6"`
	Nickname   string `json:"nickname"`
	AdminsID   int    `json:"admins_id" binding:"required"`
	AgreeTerms int    `json:"agree_terms" binding:"oneof=1"`
}

// LoginResponse 登录响应
type LoginResponse struct {
	Token string `json:"token"`
	User  UserVO `json:"user"`
}

// UserVO 用户视图对象
type UserVO struct {
	ID       int    `json:"id"`
	Phone    string `json:"phone"`
	Nickname string `json:"nickname"`
	Avatar   string `json:"avatar"`
	Role     int    `json:"role,omitempty"`
}
