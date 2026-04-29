package service

import (
	"errors"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/repository"
)

// DeviceService 设备服务
type DeviceService struct {
	deviceRepo *repository.DeviceRepository
}

// NewDeviceService 创建设备服务
func NewDeviceService() *DeviceService {
	return &DeviceService{
		deviceRepo: repository.NewDeviceRepository(),
	}
}

// GetDevices 获取设备列表
func (s *DeviceService) GetDevices(adminsID, clientID int, query *model.DeviceListQuery) (*model.DeviceResponse, error) {
	if query.Page < 1 {
		query.Page = 1
	}
	if query.PageSize < 1 || query.PageSize > 100 {
		query.PageSize = 20
	}

	devices, total, err := s.deviceRepo.List(adminsID, clientID, query)
	if err != nil {
		return nil, err
	}

	return &model.DeviceResponse{
		Total: total,
		List:  devices,
	}, nil
}

// GetDeviceByID 获取设备详情
func (s *DeviceService) GetDeviceByID(id int) (*model.Device, error) {
	device, err := s.deviceRepo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if device == nil {
		return nil, errors.New("设备不存在")
	}
	return device, nil
}

// CreateDevice 创建设备
func (s *DeviceService) CreateDevice(adminsID, clientID int, req *model.CreateDeviceRequest) error {
	device := &model.Device{
		AdminsID: adminsID,
		ClientID: clientID,
		Name:     req.Name,
		Type:     req.Type,
		Mac:      req.Mac,
		Model:    req.Model,
		RoomID:   req.RoomID,
		GroupID:  req.GroupID,
	}

	return s.deviceRepo.Create(device)
}

// UpdateDevice 更新设备
func (s *DeviceService) UpdateDevice(id int, req *model.UpdateDeviceRequest) error {
	device, err := s.deviceRepo.GetByID(id)
	if err != nil {
		return err
	}
	if device == nil {
		return errors.New("设备不存在")
	}

	if req.Name != "" {
		device.Name = req.Name
	}
	if req.Status != nil {
		device.Status = *req.Status
	}
	if req.RoomID != nil {
		device.RoomID = req.RoomID
	}
	if req.GroupID != nil {
		device.GroupID = req.GroupID
	}

	return s.deviceRepo.Update(device)
}

// DeleteDevice 删除设备
func (s *DeviceService) DeleteDevice(id int) error {
	device, err := s.deviceRepo.GetByID(id)
	if err != nil {
		return err
	}
	if device == nil {
		return errors.New("设备不存在")
	}

	return s.deviceRepo.Delete(id)
}
