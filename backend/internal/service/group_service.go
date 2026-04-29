package service

import (
	"errors"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/repository"
)

// GroupService 分组服务
type GroupService struct {
	groupRepo *repository.GroupRepository
}

// NewGroupService 创建分组服务
func NewGroupService() *GroupService {
	return &GroupService{
		groupRepo: repository.NewGroupRepository(),
	}
}

// GetGroups 获取分组列表
func (s *GroupService) GetGroups(adminsID, clientID int) ([]model.DeviceGroup, error) {
	return s.groupRepo.List(adminsID, clientID)
}

// GetGroupByID 获取分组详情
func (s *GroupService) GetGroupByID(id int) (*model.DeviceGroup, error) {
	group, err := s.groupRepo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if group == nil {
		return nil, errors.New("分组不存在")
	}
	return group, nil
}

// CreateGroup 创建分组
func (s *GroupService) CreateGroup(adminsID, clientID int, req *model.CreateGroupRequest) error {
	group := &model.DeviceGroup{
		AdminsID: adminsID,
		ClientID: clientID,
		Name:     req.Name,
		Icon:     req.Icon,
		Color:    req.Color,
		Sort:     req.Sort,
	}

	return s.groupRepo.Create(group)
}

// UpdateGroup 更新分组
func (s *GroupService) UpdateGroup(id int, req *model.UpdateGroupRequest) error {
	group, err := s.groupRepo.GetByID(id)
	if err != nil {
		return err
	}
	if group == nil {
		return errors.New("分组不存在")
	}

	if req.Name != "" {
		group.Name = req.Name
	}
	if req.Icon != "" {
		group.Icon = req.Icon
	}
	if req.Color != "" {
		group.Color = req.Color
	}
	if req.Sort != nil {
		group.Sort = *req.Sort
	}

	return s.groupRepo.Update(group)
}

// DeleteGroup 删除分组
func (s *GroupService) DeleteGroup(id int) error {
	group, err := s.groupRepo.GetByID(id)
	if err != nil {
		return err
	}
	if group == nil {
		return errors.New("分组不存在")
	}

	return s.groupRepo.Delete(id)
}
