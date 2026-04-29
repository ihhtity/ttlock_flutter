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

// GroupHandler 分组处理器
type GroupHandler struct {
	groupService *service.GroupService
}

// NewGroupHandler 创建分组处理器
func NewGroupHandler() *GroupHandler {
	return &GroupHandler{
		groupService: service.NewGroupService(),
	}
}

// List 获取分组列表
func (h *GroupHandler) List(c *gin.Context) {
	userID := c.GetInt("user_id")
	adminsID := c.GetInt("admins_id")

	groups, err := h.groupService.GetGroups(adminsID, userID)
	if err != nil {
		logger.Error("获取分组列表失败", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "服务器错误",
		})
		return
	}

	c.JSON(http.StatusOK, model.Success(groups))
}

// GetDetail 获取分组详情
func (h *GroupHandler) GetDetail(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "无效的分组ID",
		})
		return
	}

	group, err := h.groupService.GetGroupByID(id)
	if err != nil {
		logger.Error("获取分组详情失败", err, zap.Int("group_id", id))
		c.JSON(http.StatusNotFound, gin.H{
			"code":    404,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.Success(group))
}

// Create 创建分组
func (h *GroupHandler) Create(c *gin.Context) {
	userID := c.GetInt("user_id")
	adminsID := c.GetInt("admins_id")

	var req model.CreateGroupRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "参数错误: " + err.Error(),
		})
		return
	}

	if err := h.groupService.CreateGroup(adminsID, userID, &req); err != nil {
		logger.Error("创建分组失败", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "创建失败",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessWithMessage("创建成功", nil))
}

// Update 更新分组
func (h *GroupHandler) Update(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "无效的分组ID",
		})
		return
	}

	var req model.UpdateGroupRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "参数错误: " + err.Error(),
		})
		return
	}

	if err := h.groupService.UpdateGroup(id, &req); err != nil {
		logger.Error("更新分组失败", err, zap.Int("group_id", id))
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "更新失败",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessWithMessage("更新成功", nil))
}

// Delete 删除分组
func (h *GroupHandler) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "无效的分组ID",
		})
		return
	}

	if err := h.groupService.DeleteGroup(id); err != nil {
		logger.Error("删除分组失败", err, zap.Int("group_id", id))
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "删除失败",
		})
		return
	}

	c.JSON(http.StatusOK, model.SuccessWithMessage("删除成功", nil))
}
