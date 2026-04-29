-- 修改验证码表注释为中文
USE device_flutter;

DROP TABLE IF EXISTS verification_codes;

CREATE TABLE verification_codes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    code VARCHAR(10) NOT NULL COMMENT '验证码',
    type TINYINT(1) NOT NULL DEFAULT 1 COMMENT '验证码类型：1-注册，2-找回密码，3-绑定手机，4-绑定邮箱',
    status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '状态：0-未使用，1-已使用，2-已过期',
    expire_at DATETIME NOT NULL COMMENT '过期时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_phone (phone),
    INDEX idx_email (email),
    INDEX idx_code (code),
    INDEX idx_expire (expire_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='验证码表';
