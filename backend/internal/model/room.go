package model

import "time"

// Room 房间模型
type Room struct {
	ID        int       `json:"id" db:"id"`
	AdminsID  int       `json:"admins_id" db:"admins_id"`
	ClientID  int       `json:"client_id" db:"client_id"`
	Name      string    `json:"name" db:"name"`
	Type      string    `json:"type" db:"type"`
	Building  string    `json:"building" db:"building"`
	Floor     int       `json:"floor" db:"floor"`
	Status    string    `json:"status" db:"status"`
	Battery   int       `json:"battery" db:"battery"`
	Devices   string    `json:"devices" db:"devices"`
	LockData  string    `json:"lock_data" db:"lock_data"`
	LockMac   string    `json:"lock_mac" db:"lock_mac"`
	CreatedAt time.Time `json:"created_at" db:"created"`
	UpdatedAt time.Time `json:"updated_at" db:"updated"`
}

// CreateRoomRequest 创建房间请求
type CreateRoomRequest struct {
	Name     string `json:"name" binding:"required"`
	Type     string `json:"type" binding:"required"`
	Building string `json:"building" binding:"required"`
	Floor    int    `json:"floor" binding:"min=1,max=100"`
}

// UpdateRoomRequest 更新房间请求
type UpdateRoomRequest struct {
	Name     string `json:"name"`
	Type     string `json:"type"`
	Building string `json:"building"`
	Floor    *int   `json:"floor"`
	Status   string `json:"status" binding:"omitempty,oneof=vacant rented maintenance"`
}

// RoomListQuery 房间列表查询参数
type RoomListQuery struct {
	Page     int    `form:"page" binding:"min=1"`
	PageSize int    `form:"page_size" binding:"min=1,max=100"`
	Building string `form:"building"`
	Floor    *int   `form:"floor"`
	Status   string `form:"status" binding:"omitempty,oneof=vacant rented maintenance"`
	Keyword  string `form:"keyword"`
}

// RoomResponse 房间响应
type RoomResponse struct {
	Total int    `json:"total"`
	List  []Room `json:"list"`
}
