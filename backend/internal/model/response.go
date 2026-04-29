package model

// Response 统一响应格式
type Response struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

// Success 成功响应
func Success(data interface{}) Response {
	return Response{
		Code:    200,
		Message: "success",
		Data:    data,
	}
}

// SuccessWithMessage 带消息的成功响应
func SuccessWithMessage(message string, data interface{}) Response {
	return Response{
		Code:    200,
		Message: message,
		Data:    data,
	}
}

// Error 错误响应
func Error(code int, message string) Response {
	return Response{
		Code:    code,
		Message: message,
	}
}

// ErrorResponse 错误响应（带详情）
type ErrorResponse struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Error   string `json:"error,omitempty"`
}

// PageData 分页数据
type PageData struct {
	Total int         `json:"total"`
	Page  int         `json:"page"`
	Size  int         `json:"page_size"`
	List  interface{} `json:"list"`
}

// NewPageData 创建分页数据
func NewPageData(total, page, size int, list interface{}) PageData {
	return PageData{
		Total: total,
		Page:  page,
		Size:  size,
		List:  list,
	}
}
