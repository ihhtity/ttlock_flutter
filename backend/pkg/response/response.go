package response

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// ErrorCode 错误码定义
type ErrorCode int

const (
	// 成功
	CodeSuccess ErrorCode = 200

	// 客户端错误 4xx
	CodeBadRequest          ErrorCode = 400
	CodeUnauthorized        ErrorCode = 401
	CodeForbidden           ErrorCode = 403
	CodeNotFound            ErrorCode = 404
	CodeMethodNotAllowed    ErrorCode = 405
	CodeTooManyRequests     ErrorCode = 429
	CodeUnprocessableEntity ErrorCode = 422

	// 服务器错误 5xx
	CodeInternalServerError ErrorCode = 500
	CodeBadGateway          ErrorCode = 502
	CodeServiceUnavailable  ErrorCode = 503
	CodeGatewayTimeout      ErrorCode = 504
)

// Response 统一响应结构
type Response struct {
	Code    ErrorCode   `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

// Success 成功响应
func Success(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, Response{
		Code:    CodeSuccess,
		Message: "success",
		Data:    data,
	})
}

// SuccessWithMessage 带消息的成功响应
func SuccessWithMessage(c *gin.Context, message string, data interface{}) {
	c.JSON(http.StatusOK, Response{
		Code:    CodeSuccess,
		Message: message,
		Data:    data,
	})
}

// Error 错误响应
func Error(c *gin.Context, code ErrorCode, message string) {
	httpStatus := getHTTPStatus(code)
	c.JSON(httpStatus, Response{
		Code:    code,
		Message: message,
	})
}

// ErrorWithData 带数据的错误响应
func ErrorWithData(c *gin.Context, code ErrorCode, message string, data interface{}) {
	httpStatus := getHTTPStatus(code)
	c.JSON(httpStatus, Response{
		Code:    code,
		Message: message,
		Data:    data,
	})
}

// BadRequest 请求参数错误
func BadRequest(c *gin.Context, message string) {
	Error(c, CodeBadRequest, message)
}

// Unauthorized 未授权
func Unauthorized(c *gin.Context, message string) {
	Error(c, CodeUnauthorized, message)
}

// Forbidden 禁止访问
func Forbidden(c *gin.Context, message string) {
	Error(c, CodeForbidden, message)
}

// NotFound 资源不存在
func NotFound(c *gin.Context, message string) {
	Error(c, CodeNotFound, message)
}

// InternalServerError 服务器内部错误
func InternalServerError(c *gin.Context, message string) {
	Error(c, CodeInternalServerError, message)
}

// TooManyRequests 请求过于频繁
func TooManyRequests(c *gin.Context, message string) {
	Error(c, CodeTooManyRequests, message)
}

// PageResponse 分页响应结构
type PageResponse struct {
	Total int         `json:"total"`
	Page  int         `json:"page"`
	Size  int         `json:"page_size"`
	List  interface{} `json:"list"`
}

// SuccessPage 分页成功响应
func SuccessPage(c *gin.Context, total, page, pageSize int, list interface{}) {
	c.JSON(http.StatusOK, Response{
		Code:    CodeSuccess,
		Message: "success",
		Data: PageResponse{
			Total: total,
			Page:  page,
			Size:  pageSize,
			List:  list,
		},
	})
}

// getHTTPStatus 获取HTTP状态码
func getHTTPStatus(code ErrorCode) int {
	switch code {
	case CodeSuccess:
		return http.StatusOK
	case CodeBadRequest:
		return http.StatusBadRequest
	case CodeUnauthorized:
		return http.StatusUnauthorized
	case CodeForbidden:
		return http.StatusForbidden
	case CodeNotFound:
		return http.StatusNotFound
	case CodeMethodNotAllowed:
		return http.StatusMethodNotAllowed
	case CodeTooManyRequests:
		return http.StatusTooManyRequests
	case CodeUnprocessableEntity:
		return http.StatusUnprocessableEntity
	case CodeInternalServerError:
		return http.StatusInternalServerError
	case CodeBadGateway:
		return http.StatusBadGateway
	case CodeServiceUnavailable:
		return http.StatusServiceUnavailable
	case CodeGatewayTimeout:
		return http.StatusGatewayTimeout
	default:
		return http.StatusInternalServerError
	}
}
