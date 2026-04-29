-- Create verification codes table
USE device_flutter;

DROP TABLE IF EXISTS verification_codes;

CREATE TABLE verification_codes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary ID',
    phone VARCHAR(20) DEFAULT NULL COMMENT 'Phone number',
    email VARCHAR(100) DEFAULT NULL COMMENT 'Email address',
    code VARCHAR(10) NOT NULL COMMENT 'Verification code',
    type TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Code type: 1-register, 2-reset password, 3-bind phone, 4-bind email',
    status TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Status: 0-unused, 1-used, 2-expired',
    expire_at DATETIME NOT NULL COMMENT 'Expiration time',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    INDEX idx_phone (phone),
    INDEX idx_email (email),
    INDEX idx_code (code),
    INDEX idx_expire (expire_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Verification Codes Table';
