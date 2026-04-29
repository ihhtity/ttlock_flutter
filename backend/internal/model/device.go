package model

import "time"

// Device 设备模型
type Device struct {
	ID         int        `json:"id" db:"id"`
	AdminsID   int        `json:"admins_id" db:"admins_id"`
	ClientID   int        `json:"client_id" db:"client_id"`
	RoomID     *int       `json:"room_id" db:"room_id"`
	GroupID    *int       `json:"group_id" db:"group_id"`
	Name       string     `json:"name" db:"name"`
	Type       string     `json:"type" db:"type"`
	Mac        string     `json:"mac" db:"mac"`
	Model      string     `json:"model" db:"model"`
	Status     int        `json:"status" db:"status"`
	Battery    int        `json:"battery" db:"battery"`
	Firmware   string     `json:"firmware" db:"firmware"`
	Data       string     `json:"data" db:"data"`
	LastOnline *time.Time `json:"last_online" db:"last_online"`
	CreatedAt  time.Time  `json:"created_at" db:"created"`
	UpdatedAt  time.Time  `json:"updated_at" db:"updated"`
}

// DeviceGroup 设备分组模型
type DeviceGroup struct {
	ID        int       `json:"id" db:"id"`
	AdminsID  int       `json:"admins_id" db:"admins_id"`
	ClientID  int       `json:"client_id" db:"client_id"`
	Name      string    `json:"name" db:"name"`
	Icon      string    `json:"icon" db:"icon"`
	Color     string    `json:"color" db:"color"`
	Sort      int       `json:"sort" db:"sort"`
	CreatedAt time.Time `json:"created_at" db:"created"`
	UpdatedAt time.Time `json:"updated_at" db:"updated"`
}

// CreateDeviceRequest 创建设备请求
type CreateDeviceRequest struct {
	Name    string `json:"name" binding:"required"`
	Type    string `json:"type" binding:"required,oneof=lock light ac tv gateway power"`
	Mac     string `json:"mac" binding:"required"`
	Model   string `json:"model"`
	RoomID  *int   `json:"room_id"`
	GroupID *int   `json:"group_id"`
}

// UpdateDeviceRequest 更新设备请求
type UpdateDeviceRequest struct {
	Name    string `json:"name"`
	Status  *int   `json:"status"`
	RoomID  *int   `json:"room_id"`
	GroupID *int   `json:"group_id"`
}

// DeviceListQuery 设备列表查询参数
type DeviceListQuery struct {
	Page     int    `form:"page" binding:"min=1"`
	PageSize int    `form:"page_size" binding:"min=1,max=100"`
	Type     string `form:"type"`
	Status   *int   `form:"status"`
	RoomID   *int   `form:"room_id"`
	GroupID  *int   `form:"group_id"`
	Keyword  string `form:"keyword"`
}

// DeviceResponse 设备响应
type DeviceResponse struct {
	Total int       `json:"total"`
	List  []Device  `json:"list"`
}

// GroupResponse 分组响应
type GroupResponse struct {
	Total int            `json:"total"`
	List  []DeviceGroup  `json:"list"`
}

// CreateGroupRequest 创建分组请求
type CreateGroupRequest struct {
	Name   string `json:"name" binding:"required"`
	Icon   string `json:"icon"`
	Color  string `json:"color"`
	Sort   int    `json:"sort"`
}

// UpdateGroupRequest 更新分组请求
type UpdateGroupRequest struct {
	Name   string `json:"name"`
	Icon   string `json:"icon"`
	Color  string `json:"color"`
	Sort   *int   `json:"sort"`
}
