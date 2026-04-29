package jwt

import (
	"errors"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var jwtSecret []byte

// Claims JWT Claims
type Claims struct {
	UserID   int `json:"user_id"`
	AdminsID int `json:"admins_id"`
	Role     int `json:"role"`
	jwt.RegisteredClaims
}

// Init 初始化 JWT
func Init(secret string) {
	jwtSecret = []byte(secret)
}

// GenerateToken 生成 Token
func GenerateToken(userID, adminsID, role int, expireHours int) (string, error) {
	now := time.Now()
	expireTime := now.Add(time.Duration(expireHours) * time.Hour)

	claims := Claims{
		UserID:   userID,
		AdminsID: adminsID,
		Role:     role,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expireTime),
			IssuedAt:  jwt.NewNumericDate(now),
			NotBefore: jwt.NewNumericDate(now),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

// ParseToken 解析 Token
func ParseToken(tokenString string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*Claims); ok && token.Valid {
		return claims, nil
	}

	return nil, errors.New("invalid token")
}
