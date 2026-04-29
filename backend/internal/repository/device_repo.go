package repository

import (
	"database/sql"
	"fmt"
	"strings"
	"time"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/model"
)

// DeviceRepository 设备数据访问
type DeviceRepository struct{}

// NewDeviceRepository 创建设备仓库
func NewDeviceRepository() *DeviceRepository {
	return &DeviceRepository{}
}

// List 获取设备列表
func (r *DeviceRepository) List(adminsID, clientID int, query *model.DeviceListQuery) ([]model.Device, int, error) {
	db := database.GetReadDB()

	// 构建查询条件
	conditions := []string{"admins_id = ?", "client_id = ?"}
	args := []interface{}{adminsID, clientID}

	if query.Type != "" {
		conditions = append(conditions, "type = ?")
		args = append(args, query.Type)
	}

	if query.Status != nil {
		conditions = append(conditions, "status = ?")
		args = append(args, *query.Status)
	}

	if query.RoomID != nil {
		conditions = append(conditions, "room_id = ?")
		args = append(args, *query.RoomID)
	}

	if query.GroupID != nil {
		conditions = append(conditions, "group_id = ?")
		args = append(args, *query.GroupID)
	}

	if query.Keyword != "" {
		conditions = append(conditions, "(name LIKE ? OR mac LIKE ?)")
		keyword := "%" + query.Keyword + "%"
		args = append(args, keyword, keyword)
	}

	whereClause := strings.Join(conditions, " AND ")

	// 查询总数
	var total int
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM devices WHERE %s", whereClause)
	db.QueryRow(countQuery, args...).Scan(&total)

	// 查询列表
	offset := (query.Page - 1) * query.PageSize
	listQuery := fmt.Sprintf(`SELECT id, admins_id, client_id, room_id, group_id, name, type, mac, model, 
	                                 status, battery, firmware, data, last_online, created, updated 
	                          FROM devices WHERE %s ORDER BY id DESC LIMIT ? OFFSET ?`, whereClause)

	args = append(args, query.PageSize, offset)
	rows, err := db.Query(listQuery, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var devices []model.Device
	for rows.Next() {
		var d model.Device
		err := rows.Scan(
			&d.ID, &d.AdminsID, &d.ClientID, &d.RoomID, &d.GroupID,
			&d.Name, &d.Type, &d.Mac, &d.Model, &d.Status, &d.Battery,
			&d.Firmware, &d.Data, &d.LastOnline, &d.CreatedAt, &d.UpdatedAt,
		)
		if err != nil {
			return nil, 0, err
		}
		devices = append(devices, d)
	}

	return devices, total, nil
}

// GetByID 根据ID获取设备
func (r *DeviceRepository) GetByID(id int) (*model.Device, error) {
	db := database.GetReadDB()

	query := `SELECT id, admins_id, client_id, room_id, group_id, name, type, mac, model, 
	                 status, battery, firmware, data, last_online, created, updated 
	          FROM devices WHERE id = ?`

	var device model.Device
	err := db.QueryRow(query, id).Scan(
		&device.ID, &device.AdminsID, &device.ClientID, &device.RoomID, &device.GroupID,
		&device.Name, &device.Type, &device.Mac, &device.Model, &device.Status, &device.Battery,
		&device.Firmware, &device.Data, &device.LastOnline, &device.CreatedAt, &device.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &device, nil
}

// Create 创建设备
func (r *DeviceRepository) Create(device *model.Device) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `INSERT INTO devices (admins_id, client_id, room_id, group_id, name, type, mac, model, 
	                               status, battery, created, updated) 
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, 100, ?, ?)`

	result, err := db.Exec(query,
		device.AdminsID, device.ClientID, device.RoomID, device.GroupID,
		device.Name, device.Type, device.Mac, device.Model, now, now,
	)
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	device.ID = int(id)
	device.CreatedAt = now
	device.UpdatedAt = now

	return nil
}

// Update 更新设备
func (r *DeviceRepository) Update(device *model.Device) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `UPDATE devices SET name = ?, status = ?, room_id = ?, group_id = ?, updated = ? WHERE id = ?`

	_, err := db.Exec(query, device.Name, device.Status, device.RoomID, device.GroupID, now, device.ID)
	return err
}

// Delete 删除设备
func (r *DeviceRepository) Delete(id int) error {
	db := database.GetWriteDB()

	query := `DELETE FROM devices WHERE id = ?`
	_, err := db.Exec(query, id)
	return err
}
