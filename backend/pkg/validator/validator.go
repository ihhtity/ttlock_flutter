package validator

import (
	"errors"
	"regexp"
	"strings"
)

var (
	// 手机号正则（中国大陆）
	phoneRegex = regexp.MustCompile(`^1[3-9]\d{9}$`)
	// MAC地址正则
	macRegex = regexp.MustCompile(`^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$`)
	// 邮箱正则
	emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)
)

// ValidatePhone 验证手机号
func ValidatePhone(phone string) error {
	if phone == "" {
		return errors.New("手机号不能为空")
	}
	if !phoneRegex.MatchString(phone) {
		return errors.New("手机号格式不正确")
	}
	return nil
}

// ValidatePassword 验证密码
func ValidatePassword(password string) error {
	if password == "" {
		return errors.New("密码不能为空")
	}
	if len(password) < 6 {
		return errors.New("密码长度不能少于6位")
	}
	if len(password) > 50 {
		return errors.New("密码长度不能超过50位")
	}
	return nil
}

// ValidateMAC 验证MAC地址
func ValidateMAC(mac string) error {
	if mac == "" {
		return errors.New("MAC地址不能为空")
	}
	if !macRegex.MatchString(mac) {
		return errors.New("MAC地址格式不正确，例如：AA:BB:CC:DD:EE:FF")
	}
	return nil
}

// ValidateEmail 验证邮箱
func ValidateEmail(email string) error {
	if email == "" {
		return errors.New("邮箱不能为空")
	}
	if !emailRegex.MatchString(email) {
		return errors.New("邮箱格式不正确")
	}
	return nil
}

// ValidateName 验证名称
func ValidateName(name string, fieldName string, minLen, maxLen int) error {
	if name == "" {
		return errors.New(fieldName + "不能为空")
	}
	if len(name) < minLen {
		return errors.New(fieldName + "长度不能少于" + string(rune(minLen)) + "位")
	}
	if len(name) > maxLen {
		return errors.New(fieldName + "长度不能超过" + string(rune(maxLen)) + "位")
	}
	return nil
}

// SanitizeString 清理字符串（去除首尾空格、防止XSS）
func SanitizeString(s string) string {
	s = strings.TrimSpace(s)
	// 简单的HTML转义
	s = strings.ReplaceAll(s, "<", "&lt;")
	s = strings.ReplaceAll(s, ">", "&gt;")
	s = strings.ReplaceAll(s, "\"", "&quot;")
	s = strings.ReplaceAll(s, "'", "&#39;")
	return s
}

// ValidatePageParams 验证分页参数
func ValidatePageParams(page, pageSize int) (int, int, error) {
	if page < 1 {
		page = 1
	}
	if pageSize < 1 || pageSize > 100 {
		pageSize = 20
	}
	return page, pageSize, nil
}

// IsEmpty 检查字符串是否为空
func IsEmpty(s string) bool {
	return strings.TrimSpace(s) == ""
}

// InArray 检查值是否在数组中
func InArray(value string, array []string) bool {
	for _, v := range array {
		if v == value {
			return true
		}
	}
	return false
}
