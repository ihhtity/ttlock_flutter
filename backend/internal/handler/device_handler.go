package handler

import (
	"strconv"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/service"
	"ttlock-backend/pkg/logger"
	"ttlock-backend/pkg/response"
	"go.uber.org/zap"

	"github.com/gin-gonic/gin"
)

// DeviceHandler 设备处理器
type DeviceHandler struct {
	deviceService *service.DeviceService
}

// NewDeviceHandler 创建设备处理器
func NewDeviceHandler() *DeviceHandler {
	return &DeviceHandler{
		deviceService: service.NewDeviceService(),
	}
}

// List 获取设备列表
func (h *DeviceHandler) List(c *gin.Context) {
	userID := c.GetInt("user_id")
	adminsID := c.GetInt("admins_id")

	var query model.DeviceListQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	result, err := h.deviceService.GetDevices(adminsID, userID, &query)
	if err != nil {
		logger.Error("获取设备列表失败", err)
		response.InternalServerError(c, "服务器错误")
		return
	}

	response.SuccessPage(c, result.Total, query.Page, query.PageSize, result.List)
}

// GetDetail 获取设备详情
func (h *DeviceHandler) GetDetail(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "无效的设备ID")
		return
	}

	device, err := h.deviceService.GetDeviceByID(id)
	if err != nil {
		logger.Error("获取设备详情失败", err, zap.Int("device_id", id))
		response.NotFound(c, err.Error())
		return
	}

	response.Success(c, device)
}

// Create 创建设备
func (h *DeviceHandler) Create(c *gin.Context) {
	userID := c.GetInt("user_id")
	adminsID := c.GetInt("admins_id")

	var req model.CreateDeviceRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	if err := h.deviceService.CreateDevice(adminsID, userID, &req); err != nil {
		logger.Error("创建设备失败", err)
		response.InternalServerError(c, "创建失败")
		return
	}

	response.SuccessWithMessage(c, "创建成功", nil)
}

// Update 更新设备
func (h *DeviceHandler) Update(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "无效的设备ID")
		return
	}

	var req model.UpdateDeviceRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "参数错误: "+err.Error())
		return
	}

	if err := h.deviceService.UpdateDevice(id, &req); err != nil {
		logger.Error("更新设备失败", err, zap.Int("device_id", id))
		response.InternalServerError(c, "更新失败")
		return
	}

	response.SuccessWithMessage(c, "更新成功", nil)
}

// Delete 删除设备
func (h *DeviceHandler) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "无效的设备ID")
		return
	}

	if err := h.deviceService.DeleteDevice(id); err != nil {
		logger.Error("删除设备失败", err, zap.Int("device_id", id))
		response.InternalServerError(c, "删除失败")
		return
	}

	response.SuccessWithMessage(c, "删除成功", nil)
}
