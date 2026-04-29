package service

import (
	"errors"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/repository"
)

// RoomService 房间服务
type RoomService struct {
	roomRepo *repository.RoomRepository
}

// NewRoomService 创建房间服务
func NewRoomService() *RoomService {
	return &RoomService{
		roomRepo: repository.NewRoomRepository(),
	}
}

// GetRooms 获取房间列表
func (s *RoomService) GetRooms(adminsID, clientID int, query *model.RoomListQuery) (*model.RoomResponse, error) {
	if query.Page < 1 {
		query.Page = 1
	}
	if query.PageSize < 1 || query.PageSize > 100 {
		query.PageSize = 20
	}

	rooms, total, err := s.roomRepo.List(adminsID, clientID, query)
	if err != nil {
		return nil, err
	}

	return &model.RoomResponse{
		Total: total,
		List:  rooms,
	}, nil
}

// GetRoomByID 获取房间详情
func (s *RoomService) GetRoomByID(id int) (*model.Room, error) {
	room, err := s.roomRepo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if room == nil {
		return nil, errors.New("房间不存在")
	}
	return room, nil
}

// CreateRoom 创建房间
func (s *RoomService) CreateRoom(adminsID, clientID int, req *model.CreateRoomRequest) error {
	room := &model.Room{
		AdminsID: adminsID,
		ClientID: clientID,
		Name:     req.Name,
		Type:     req.Type,
		Building: req.Building,
		Floor:    req.Floor,
	}

	return s.roomRepo.Create(room)
}

// UpdateRoom 更新房间
func (s *RoomService) UpdateRoom(id int, req *model.UpdateRoomRequest) error {
	room, err := s.roomRepo.GetByID(id)
	if err != nil {
		return err
	}
	if room == nil {
		return errors.New("房间不存在")
	}

	if req.Name != "" {
		room.Name = req.Name
	}
	if req.Type != "" {
		room.Type = req.Type
	}
	if req.Building != "" {
		room.Building = req.Building
	}
	if req.Floor != nil {
		room.Floor = *req.Floor
	}
	if req.Status != "" {
		room.Status = req.Status
	}

	return s.roomRepo.Update(room)
}

// DeleteRoom 删除房间
func (s *RoomService) DeleteRoom(id int) error {
	room, err := s.roomRepo.GetByID(id)
	if err != nil {
		return err
	}
	if room == nil {
		return errors.New("房间不存在")
	}

	return s.roomRepo.Delete(id)
}
