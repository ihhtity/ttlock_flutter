package repository

import (
	"database/sql"
	"fmt"
	"strings"
	"time"
	"ttlock-backend/internal/database"
	"ttlock-backend/internal/model"
)

// GroupRepository 分组数据访问
type GroupRepository struct{}

// NewGroupRepository 创建分组仓库
func NewGroupRepository() *GroupRepository {
	return &GroupRepository{}
}

// List 获取分组列表
func (r *GroupRepository) List(adminsID, clientID int) ([]model.DeviceGroup, error) {
	db := database.GetReadDB()

	query := `SELECT id, admins_id, client_id, name, icon, color, sort, created, updated 
	          FROM device_groups 
	          WHERE admins_id = ? AND client_id = ? 
	          ORDER BY sort ASC, id DESC`

	rows, err := db.Query(query, adminsID, clientID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var groups []model.DeviceGroup
	for rows.Next() {
		var g model.DeviceGroup
		err := rows.Scan(
			&g.ID, &g.AdminsID, &g.ClientID, &g.Name, &g.Icon,
			&g.Color, &g.Sort, &g.CreatedAt, &g.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		groups = append(groups, g)
	}

	return groups, nil
}

// GetByID 根据ID获取分组
func (r *GroupRepository) GetByID(id int) (*model.DeviceGroup, error) {
	db := database.GetReadDB()

	query := `SELECT id, admins_id, client_id, name, icon, color, sort, created, updated 
	          FROM device_groups WHERE id = ?`

	var group model.DeviceGroup
	err := db.QueryRow(query, id).Scan(
		&group.ID, &group.AdminsID, &group.ClientID, &group.Name, &group.Icon,
		&group.Color, &group.Sort, &group.CreatedAt, &group.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &group, nil
}

// Create 创建分组
func (r *GroupRepository) Create(group *model.DeviceGroup) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `INSERT INTO device_groups (admins_id, client_id, name, icon, color, sort, created, updated) 
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?)`

	result, err := db.Exec(query,
		group.AdminsID, group.ClientID, group.Name, group.Icon,
		group.Color, group.Sort, now, now,
	)
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	group.ID = int(id)
	group.CreatedAt = now
	group.UpdatedAt = now

	return nil
}

// Update 更新分组
func (r *GroupRepository) Update(group *model.DeviceGroup) error {
	db := database.GetWriteDB()

	now := time.Now()
	query := `UPDATE device_groups SET name = ?, icon = ?, color = ?, sort = ?, updated = ? WHERE id = ?`

	_, err := db.Exec(query, group.Name, group.Icon, group.Color, group.Sort, now, group.ID)
	return err
}

// Delete 删除分组
func (r *GroupRepository) Delete(id int) error {
	db := database.GetWriteDB()

	query := `DELETE FROM device_groups WHERE id = ?`
	_, err := db.Exec(query, id)
	return err
}

// GetByIDs 批量获取分组
func (r *GroupRepository) GetByIDs(ids []int) ([]model.DeviceGroup, error) {
	if len(ids) == 0 {
		return []model.DeviceGroup{}, nil
	}

	db := database.GetReadDB()

	placeholders := strings.Repeat("?,", len(ids))
	placeholders = placeholders[:len(placeholders)-1]

	query := fmt.Sprintf(`SELECT id, admins_id, client_id, name, icon, color, sort, created, updated 
	                      FROM device_groups WHERE id IN (%s)`, placeholders)

	args := make([]interface{}, len(ids))
	for i, id := range ids {
		args[i] = id
	}

	rows, err := db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var groups []model.DeviceGroup
	for rows.Next() {
		var g model.DeviceGroup
		err := rows.Scan(
			&g.ID, &g.AdminsID, &g.ClientID, &g.Name, &g.Icon,
			&g.Color, &g.Sort, &g.CreatedAt, &g.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		groups = append(groups, g)
	}

	return groups, nil
}
