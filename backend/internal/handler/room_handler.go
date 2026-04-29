package handler

import (
	"net/http"
	"strconv"
	"ttlock-backend/internal/model"
	"ttlock-backend/internal/service"
	"ttlock-backend/pkg/logger"
	"go.uber.org/zap"

	"github.com/gin-gonic/gin"
)

// RoomHandler 房间处理器
type RoomHandler struct {
	roomService *service.RoomService
}

// NewRoomHandler 创建房间处理器
func NewRoomHandler() *RoomHandler {
	return &RoomHandler{
		roomService: service.NewRoomService(),
	}
}

// List 获取房间列表
func (h *RoomHandler) List(c *gin.Context) {
	userID := c.GetInt("user_id")
	adminsID := c.GetInt("admins_id")

	var query model.RoomListQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "参数错误: " + err.Error(),
		})
		return
	}

	result, err := h.roomService.GetRooms(adminsID, userID, &query)
	if err != nil {
		logger.Error("获取房间列表失败", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "服务器错误",
		})
		return
	}

	c.JSON(http.StatusOK, model.Success(result))
}

// GetDetail 获取房间详情
func (h *RoomHandler) GetDetail(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "无效的房间ID",
		})
		return
	}

	room, err := h.roomService.GetRoomByID(id)
	if err != nil {
		logger.Error("获取房间详情失败", err, zap.Int("room_id", id))
		c.JSON(http.StatusNotFound, gin.H{
			"code":    404,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.Success(room))
}

// Create 创建房间
func (h *RoomHandler) Create(c *gin.Context) {
	userID := c.GetInt("user_id")
	adminsID := c.GetInt("admins_id")

	var req model.CreateRoomRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "参数错误: " + err.Error(),
		})
		return
	}

	if err := h.roomService.CreateRoom(adminsID, userID, &req); err != nil {
		logger.Error("创建房间失败", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "创建失败",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessWithMessage("创建成功", nil))
}

// Update 更新房间
func (h *RoomHandler) Update(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "无效的房间ID",
		})
		return
	}

	var req model.UpdateRoomRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "参数错误: " + err.Error(),
		})
		return
	}

	if err := h.roomService.UpdateRoom(id, &req); err != nil {
		logger.Error("更新房间失败", err, zap.Int("room_id", id))
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "更新失败",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessWithMessage("更新成功", nil))
}

// Delete 删除房间
func (h *RoomHandler) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "无效的房间ID",
		})
		return
	}

	if err := h.roomService.DeleteRoom(id); err != nil {
		logger.Error("删除房间失败", err, zap.Int("room_id", id))
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "删除失败",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessWithMessage("删除成功", nil))
}
