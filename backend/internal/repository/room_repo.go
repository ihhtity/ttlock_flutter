package repository

import (
	"database/sql"
	"fmt"
	"strings"
	"time"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/model"
)

// RoomRepository 房间数据访问
type RoomRepository struct{}

// NewRoomRepository 创建房间仓库
func NewRoomRepository() *RoomRepository {
	return &RoomRepository{}
}

// List 获取房间列表
func (r *RoomRepository) List(adminsID, clientID int, query *model.RoomListQuery) ([]model.Room, int, error) {
	db := database.GetReadDB()

	// 构建查询条件
	conditions := []string{"admins_id = ?", "client_id = ?"}
	args := []interface{}{adminsID, clientID}

	if query.Building != "" {
		conditions = append(conditions, "building = ?")
		args = append(args, query.Building)
	}

	if query.Floor != nil {
		conditions = append(conditions, "floor = ?")
		args = append(args, *query.Floor)
	}

	if query.Status != "" {
		conditions = append(conditions, "status = ?")
		args = append(args, query.Status)
	}

	if query.Keyword != "" {
		conditions = append(conditions, "(name LIKE ? OR building LIKE ?)")
		keyword := "%" + query.Keyword + "%"
		args = append(args, keyword, keyword)
	}

	whereClause := strings.Join(conditions, " AND ")

	// 查询总数
	var total int
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM rooms WHERE %s", whereClause)
	db.QueryRow(countQuery, args...).Scan(&total)

	// 查询列表
	offset := (query.Page - 1) * query.PageSize
	listQuery := fmt.Sprintf(`SELECT id, admins_id, client_id, name, type, building, floor, status, 
	                                 battery, devices, lock_data, lock_mac, created, updated 
	                          FROM rooms WHERE %s ORDER BY id DESC LIMIT ? OFFSET ?`, whereClause)

	args = append(args, query.PageSize, offset)
	rows, err := db.Query(listQuery, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var rooms []model.Room
	for rows.Next() {
		var room model.Room
		err := rows.Scan(
			&room.ID, &room.AdminsID, &room.ClientID, &room.Name, &room.Type,
			&room.Building, &room.Floor, &room.Status, &room.Battery,
			&room.Devices, &room.LockData, &room.LockMac, &room.CreatedAt, &room.UpdatedAt,
		)
		if err != nil {
			return nil, 0, err
		}
		rooms = append(rooms, room)
	}

	return rooms, total, nil
}

// GetByID 根据ID获取房间
func (r *RoomRepository) GetByID(id int) (*model.Room, error) {
	db := database.GetReadDB()

	query := `SELECT id, admins_id, client_id, name, type, building, floor, status, 
	                 battery, devices, lock_data, lock_mac, created, updated 
	          FROM rooms WHERE id = ?`

	var room model.Room
	err := db.QueryRow(query, id).Scan(
		&room.ID, &room.AdminsID, &room.ClientID, &room.Name, &room.Type,
		&room.Building, &room.Floor, &room.Status, &room.Battery,
		&room.Devices, &room.LockData, &room.LockMac, &room.CreatedAt, &room.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &room, nil
}

// Create 创建房间
func (r *RoomRepository) Create(room *model.Room) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `INSERT INTO rooms (admins_id, client_id, name, type, building, floor, status, battery, created, updated) 
	          VALUES (?, ?, ?, ?, ?, ?, 'vacant', 100, ?, ?)`

	result, err := db.Exec(query,
		room.AdminsID, room.ClientID, room.Name, room.Type,
		room.Building, room.Floor, now, now,
	)
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	room.ID = int(id)
	room.CreatedAt = now
	room.UpdatedAt = now

	return nil
}

// Update 更新房间
func (r *RoomRepository) Update(room *model.Room) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `UPDATE rooms SET name = ?, type = ?, building = ?, floor = ?, status = ?, updated = ? WHERE id = ?`

	_, err := db.Exec(query, room.Name, room.Type, room.Building, room.Floor, room.Status, now, room.ID)
	return err
}

// Delete 删除房间
func (r *RoomRepository) Delete(id int) error {
	db := database.GetWriteDB()

	query := `DELETE FROM rooms WHERE id = ?`
	_, err := db.Exec(query, id)
	return err
}
