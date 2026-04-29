package handler

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"ttlock-backend/internal/model"
	"ttlock-backend/pkg/response"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// TestMain 设置测试环境
func TestMain(m *testing.M) {
	// 设置Gin为测试模式
	gin.SetMode(gin.TestMode)
	m.Run()
}

// TestAuthHandler_Login 测试登录接口
func TestAuthHandler_Login(t *testing.T) {
	// 创建测试引擎
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	// 模拟请求数据
	loginReq := model.LoginRequest{
		Phone:    "13800138000",
		Password: "123456",
	}

	// 序列化请求体
	body, _ := json.Marshal(loginReq)
	c.Request, _ = http.NewRequest("POST", "/api/v1/auth/login", bytes.NewBuffer(body))
	c.Request.Header.Set("Content-Type", "application/json")

	// TODO: 这里需要初始化handler和依赖
	// handler := NewAuthHandler()
	// handler.Login(c)

	// 验证响应
	assert.Equal(t, http.StatusOK, w.Code)

	var resp response.Response
	json.Unmarshal(w.Body.Bytes(), &resp)
	assert.Equal(t, response.CodeSuccess, resp.Code)
}

// TestAuthHandler_Register 测试注册接口
func TestAuthHandler_Register(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	registerReq := model.RegisterRequest{
		Phone:      "13900139000",
		Password:   "123456",
		Nickname:   "测试用户",
		AdminsId:   1,
		AgreeTerms: true,
	}

	body, _ := json.Marshal(registerReq)
	c.Request, _ = http.NewRequest("POST", "/api/v1/auth/register", bytes.NewBuffer(body))
	c.Request.Header.Set("Content-Type", "application/json")

	// TODO: 初始化handler
	// handler := NewAuthHandler()
	// handler.Register(c)

	assert.Equal(t, http.StatusOK, w.Code)
}

// TestDeviceHandler_List 测试设备列表接口
func TestDeviceHandler_List(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	c.Request, _ = http.NewRequest("GET", "/api/v1/devices?page=1&page_size=20", nil)

	// 添加认证Token（如果需要）
	c.Request.Header.Set("Authorization", "Bearer test_token")

	// TODO: 初始化handler
	// handler := NewDeviceHandler()
	// handler.List(c)

	assert.Equal(t, http.StatusOK, w.Code)
}

// TestRoomHandler_List 测试房间列表接口
func TestRoomHandler_List(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	c.Request, _ = http.NewRequest("GET", "/api/v1/rooms?page=1&page_size=20", nil)
	c.Request.Header.Set("Authorization", "Bearer test_token")

	// TODO: 初始化handler
	// handler := NewRoomHandler()
	// handler.List(c)

	assert.Equal(t, http.StatusOK, w.Code)
}

// TestGroupHandler_List 测试分组列表接口
func TestGroupHandler_List(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	c.Request, _ = http.NewRequest("GET", "/api/v1/groups", nil)
	c.Request.Header.Set("Authorization", "Bearer test_token")

	// TODO: 初始化handler
	// handler := NewGroupHandler()
	// handler.List(c)

	assert.Equal(t, http.StatusOK, w.Code)
}
