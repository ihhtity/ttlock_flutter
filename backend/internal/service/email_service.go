package service

import (
	"crypto/tls"
	"fmt"
	"net/smtp"
	"ttlock-backend/internal/config"
)

// EmailService 邮件服务
type EmailService struct {
	config *config.EmailConfig
}

// NewEmailService 创建邮件服务
func NewEmailService(cfg *config.EmailConfig) *EmailService {
	return &EmailService{
		config: cfg,
	}
}

// SendVerificationCode 发送验证码邮件
func (s *EmailService) SendVerificationCode(to string, code string) error {
	if !s.config.Enabled {
		return fmt.Errorf("邮件服务未启用")
	}

	subject := "宝士力得 - 验证码"
	body := fmt.Sprintf(`
		<html>
		<body>
			<h2>宝士力得验证码</h2>
			<p>您的验证码是：<strong style="font-size: 24px; color: #1890ff;">%s</strong></p>
			<p>验证码有效期为5分钟，请尽快使用。</p>
			<p>如果这不是您本人的操作，请忽略此邮件。</p>
			<hr>
			<p style="color: #999; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
		</body>
		</html>
	`, code)

	return s.sendEmail(to, subject, body)
}

// sendEmail 发送邮件
func (s *EmailService) sendEmail(to, subject, body string) error {
	auth := smtp.PlainAuth("", s.config.Username, s.config.Password, s.config.Host)

	headers := make(map[string]string)
	headers["From"] = fmt.Sprintf("%s <%s>", s.config.FromName, s.config.Username)
	headers["To"] = to
	headers["Subject"] = subject
	headers["MIME-Version"] = "1.0"
	headers["Content-Type"] = "text/html; charset=UTF-8"

	message := ""
	for k, v := range headers {
		message += fmt.Sprintf("%s: %s\r\n", k, v)
	}
	message += "\r\n" + body

	addr := fmt.Sprintf("%s:%d", s.config.Host, s.config.Port)

	if s.config.UseTLS || s.config.Port == 465 {
		// 使用 SSL/TLS 连接
		tlsConfig := &tls.Config{
			InsecureSkipVerify: false,
			ServerName:         s.config.Host,
		}
		
		conn, err := tls.Dial("tcp", addr, tlsConfig)
		if err != nil {
			return fmt.Errorf("TLS连接失败: %w", err)
		}
		defer conn.Close()

		client, err := smtp.NewClient(conn, s.config.Host)
		if err != nil {
			return fmt.Errorf("创建SMTP客户端失败: %w", err)
		}
		defer client.Quit()

		if err = client.Auth(auth); err != nil {
			return fmt.Errorf("SMTP认证失败: %w", err)
		}

		if err = client.Mail(s.config.Username); err != nil {
			return fmt.Errorf("设置发件人失败: %w", err)
		}

		if err = client.Rcpt(to); err != nil {
			return fmt.Errorf("设置收件人失败: %w", err)
		}

		w, err := client.Data()
		if err != nil {
			return fmt.Errorf("获取数据写入器失败: %w", err)
		}

		_, err = w.Write([]byte(message))
		if err != nil {
			return fmt.Errorf("写入邮件内容失败: %w", err)
		}

		err = w.Close()
		if err != nil {
			return fmt.Errorf("关闭数据写入器失败: %w", err)
		}
	} else {
		// 不使用 TLS（端口 587 STARTTLS）
		conn, err := smtp.Dial(addr)
		if err != nil {
			return fmt.Errorf("连接SMTP服务器失败: %w", err)
		}
		defer conn.Quit()

		if err = conn.StartTLS(&tls.Config{
			ServerName: s.config.Host,
		}); err != nil {
			return fmt.Errorf("STARTTLS失败: %w", err)
		}

		if err = conn.Auth(auth); err != nil {
			return fmt.Errorf("SMTP认证失败: %w", err)
		}

		if err = conn.Mail(s.config.Username); err != nil {
			return fmt.Errorf("设置发件人失败: %w", err)
		}

		if err = conn.Rcpt(to); err != nil {
			return fmt.Errorf("设置收件人失败: %w", err)
		}

		w, err := conn.Data()
		if err != nil {
			return fmt.Errorf("获取数据写入器失败: %w", err)
		}

		_, err = w.Write([]byte(message))
		if err != nil {
			return fmt.Errorf("写入邮件内容失败: %w", err)
		}

		err = w.Close()
		if err != nil {
			return fmt.Errorf("关闭数据写入器失败: %w", err)
		}
	}

	return nil
}
