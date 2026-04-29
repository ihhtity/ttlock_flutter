-- ============================================
-- 设备管理系统 - 拆分后的用户表
-- 数据库：device_flutter
-- 创建时间: 2026-04-29
-- 说明：将用户表拆分为管理端和用户端
-- ============================================

USE device_flutter;

-- ============================================
-- 0. 清理旧表 (按外键依赖顺序删除)
-- ============================================
DROP TABLE IF EXISTS `device_operation_logs`;
DROP TABLE IF EXISTS `consumption_records`;
DROP TABLE IF EXISTS `device_transfer_logs`;
DROP TABLE IF EXISTS `help_feedback`;
DROP TABLE IF EXISTS `user_settings`;
DROP TABLE IF EXISTS `family_members`;
DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `payment_accounts`;
DROP TABLE IF EXISTS `sub_accounts`;
DROP TABLE IF EXISTS `vendors`;
DROP TABLE IF EXISTS `device_rules`;
DROP TABLE IF EXISTS `device_groups`;
DROP TABLE IF EXISTS `devices`;
DROP TABLE IF EXISTS `rooms`;
DROP TABLE IF EXISTS `clients`;
DROP TABLE IF EXISTS `admins`;

-- ============================================
-- 1. 管理端用户表 (admins)
-- ============================================
CREATE TABLE `admins` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '管理员ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `role` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '角色：1-超级管理员 2-普通管理员 3-运维人员',
  `permissions` TEXT DEFAULT NULL COMMENT '权限列表JSON',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
  `agree_terms` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否同意用户协议和隐私政策：0-未同意，1-已同意',
  `last_login` DATETIME DEFAULT NULL COMMENT '最后登录',
  `login_count` INT UNSIGNED DEFAULT 0 COMMENT '登录次数',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_phone` (`phone`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理端用户表';

-- ============================================
-- 2. 用户端用户表 (clients)
-- ============================================
DROP TABLE IF EXISTS `clients`;

CREATE TABLE `clients` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '用户ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `country` VARCHAR(10) NOT NULL DEFAULT 'CN' COMMENT '国家代码',
  `dial_code` VARCHAR(10) NOT NULL DEFAULT '+86' COMMENT '电话区号',
  `agree_terms` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '同意用户协议和隐私政策',
  `phone_bound` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '手机已绑定',
  `email_bound` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '邮箱已绑定',
  `is_vendor` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否为厂商：0-否 1-是',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
  `last_login` DATETIME DEFAULT NULL COMMENT '最后登录',
  `login_count` INT UNSIGNED DEFAULT 0 COMMENT '登录次数',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone` (`phone`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_is_vendor` (`is_vendor`),
  KEY `idx_status` (`status`),
  KEY `idx_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户端用户表';

-- ============================================
-- 3. 调整房间表 - 关联用户端
-- ============================================
DROP TABLE IF EXISTS `rooms`;

CREATE TABLE `rooms` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '房间ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '所属用户ID',
  `name` VARCHAR(50) NOT NULL COMMENT '房间名称',
  `type` VARCHAR(50) NOT NULL COMMENT '房间类型',
  `building` VARCHAR(50) NOT NULL COMMENT '所属楼栋',
  `floor` INT UNSIGNED NOT NULL COMMENT '所属楼层',
  `status` VARCHAR(20) NOT NULL DEFAULT 'vacant' COMMENT '房态：vacant空闲/rented租用/maintenance维修',
  `battery` INT UNSIGNED DEFAULT 100 COMMENT '设备电量',
  `devices` VARCHAR(255) DEFAULT NULL COMMENT '设备列表JSON',
  `lock_data` TEXT DEFAULT NULL COMMENT '智能锁数据',
  `lock_mac` VARCHAR(50) DEFAULT NULL COMMENT '智能锁MAC地址',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_building` (`building`),
  KEY `idx_floor` (`floor`),
  KEY `idx_status` (`status`),
  
  CONSTRAINT `fk_rooms_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房间表';

-- ============================================
-- 4. 调整设备表 - 关联用户端
-- ============================================
DROP TABLE IF EXISTS `devices`;

CREATE TABLE `devices` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '设备ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '所属用户ID',
  `room_id` INT UNSIGNED DEFAULT NULL COMMENT '所属房间ID',
  `group_id` INT UNSIGNED DEFAULT NULL COMMENT '所属分组ID',
  `name` VARCHAR(100) NOT NULL COMMENT '设备名称',
  `type` VARCHAR(50) NOT NULL COMMENT '设备类型：lock锁/light灯/ac空调/tv电视/gateway网关',
  `mac` VARCHAR(50) NOT NULL COMMENT 'MAC地址',
  `model` VARCHAR(100) DEFAULT NULL COMMENT '设备型号',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：0-离线 1-在线 2-故障',
  `battery` INT UNSIGNED DEFAULT 100 COMMENT '电量',
  `firmware` VARCHAR(50) DEFAULT NULL COMMENT '固件版本',
  `data` TEXT DEFAULT NULL COMMENT '设备配置数据JSON',
  `last_online` DATETIME DEFAULT NULL COMMENT '最后在线时间',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mac` (`mac`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_room_id` (`room_id`),
  KEY `idx_group_id` (`group_id`),
  KEY `idx_type` (`type`),
  KEY `idx_status` (`status`),
  
  CONSTRAINT `fk_devices_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_devices_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备表';

-- ============================================
-- 5. 调整其他关联用户端的表
-- ============================================

-- 5.设备分组表
DROP TABLE IF EXISTS `device_groups`;
CREATE TABLE `device_groups` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '分组ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '所属用户ID',
  `name` VARCHAR(100) NOT NULL COMMENT '分组名称',
  `icon` VARCHAR(50) DEFAULT NULL COMMENT '图标名称',
  `color` VARCHAR(20) DEFAULT NULL COMMENT '颜色值',
  `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_sort` (`sort`),
  CONSTRAINT `fk_groups_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备分组表';

-- 6.设备规则表
DROP TABLE IF EXISTS `device_rules`;
CREATE TABLE `device_rules` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '规则ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '所属用户ID',
  `device_id` INT UNSIGNED DEFAULT NULL COMMENT '设备ID',
  `name` VARCHAR(100) NOT NULL COMMENT '规则名称',
  `type` VARCHAR(50) NOT NULL COMMENT '规则类型：schedule定时/automation自动化',
  `trigger` TEXT NOT NULL COMMENT '触发条件JSON',
  `action` TEXT NOT NULL COMMENT '执行动作JSON',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_enabled` (`enabled`),
  CONSTRAINT `fk_rules_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rules_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备规则表';

-- 7.厂商表
DROP TABLE IF EXISTS `vendors`;
CREATE TABLE `vendors` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '厂商ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED DEFAULT NULL COMMENT '关联用户ID（可选）',
  `name` VARCHAR(100) NOT NULL COMMENT '厂商名称',
  `code` VARCHAR(50) NOT NULL COMMENT '厂商编码',
  `contact` VARCHAR(100) DEFAULT NULL COMMENT '联系人',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '联系邮箱',
  `address` VARCHAR(255) DEFAULT NULL COMMENT '地址',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_vendors_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='厂商表';

-- 8.子账号表
DROP TABLE IF EXISTS `sub_accounts`;
CREATE TABLE `sub_accounts` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '子账号ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `role` VARCHAR(50) NOT NULL DEFAULT 'user' COMMENT '角色',
  `permissions` TEXT DEFAULT NULL COMMENT '权限列表JSON',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
  `last_login` DATETIME DEFAULT NULL COMMENT '最后登录',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_sub_admin` FOREIGN KEY (`admins_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='子账号表';

-- 9.收款账号表
DROP TABLE IF EXISTS `payment_accounts`;
CREATE TABLE `payment_accounts` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '账号ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED DEFAULT NULL COMMENT '关联用户ID（可选）',
  `type` VARCHAR(50) NOT NULL COMMENT '类型：wechat微信/alipay支付宝/bank银行卡',
  `name` VARCHAR(100) NOT NULL COMMENT '账号名称',
  `account` VARCHAR(100) NOT NULL COMMENT '账号',
  `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
  `is_default` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否默认',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_default` (`is_default`),
  CONSTRAINT `fk_payment_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收款账号表';

-- 10.订单表
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '订单ID',
  `order_no` VARCHAR(50) NOT NULL COMMENT '订单号',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '用户ID',
  `title` VARCHAR(200) NOT NULL COMMENT '订单标题',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '金额',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态：pending待支付/completed已完成/cancelled已取消/refunded已退款',
  `pay_type` VARCHAR(50) DEFAULT NULL COMMENT '支付方式',
  `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created` (`created`),
  CONSTRAINT `fk_orders_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- 11.消息通知表
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '消息ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '用户ID',
  `type` VARCHAR(50) NOT NULL COMMENT '类型：system系统/order订单/device设备',
  `title` VARCHAR(200) NOT NULL COMMENT '标题',
  `content` TEXT NOT NULL COMMENT '内容',
  `is_read` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  `related_id` INT UNSIGNED DEFAULT NULL COMMENT '关联ID',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created` (`created`),
  CONSTRAINT `fk_messages_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息通知表';

-- 12.家庭成员表
DROP TABLE IF EXISTS `family_members`;
CREATE TABLE `family_members` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '成员ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '所属用户ID',
  `name` VARCHAR(50) NOT NULL COMMENT '姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `relation` VARCHAR(50) DEFAULT NULL COMMENT '关系',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像',
  `permissions` TEXT DEFAULT NULL COMMENT '权限JSON',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_family_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='家庭成员表';

-- 13.个人设置表
DROP TABLE IF EXISTS `user_settings`;
CREATE TABLE `user_settings` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '设置ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED DEFAULT NULL COMMENT '用户ID（为空时代表管理员设置）',
  `key` VARCHAR(100) NOT NULL COMMENT '设置键',
  `value` TEXT NOT NULL COMMENT '设置值',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_admins_client_key` (`admins_id`, `client_id`, `key`),
  CONSTRAINT `fk_settings_admin` FOREIGN KEY (`admins_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_settings_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人设置表';

-- 14.帮助反馈表
DROP TABLE IF EXISTS `help_feedback`;
CREATE TABLE `help_feedback` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '反馈ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '用户ID',
  `type` VARCHAR(50) NOT NULL COMMENT '类型：bug反馈/suggestion建议/question问题',
  `title` VARCHAR(200) NOT NULL COMMENT '标题',
  `content` TEXT NOT NULL COMMENT '内容',
  `images` TEXT DEFAULT NULL COMMENT '图片URL列表JSON',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态：pending待处理/processing处理中/resolved已解决',
  `reply` TEXT DEFAULT NULL COMMENT '回复内容',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_type` (`type`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_feedback_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帮助反馈表';

-- 15.设备转移记录表
DROP TABLE IF EXISTS `device_transfer_logs`;
CREATE TABLE `device_transfer_logs` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '记录ID',
  `device_id` INT UNSIGNED NOT NULL COMMENT '设备ID',
  `from_admins_id` INT UNSIGNED NOT NULL COMMENT '转出管理者ID',
  `to_admins_id` INT UNSIGNED NOT NULL COMMENT '转入管理者ID',
  `reason` VARCHAR(500) DEFAULT NULL COMMENT '转移原因',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态：pending待确认/completed已完成/cancelled已取消',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `completed` DATETIME DEFAULT NULL COMMENT '完成时间',
  PRIMARY KEY (`id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_from_admins` (`from_admins_id`),
  KEY `idx_to_admins` (`to_admins_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_transfer_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transfer_from` FOREIGN KEY (`from_admins_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transfer_to` FOREIGN KEY (`to_admins_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备转移记录表';

-- 16.消费记录表
DROP TABLE IF EXISTS `consumption_records`;
CREATE TABLE `consumption_records` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '记录ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '所属用户ID',
  `order_id` INT UNSIGNED DEFAULT NULL COMMENT '关联订单ID',
  `type` VARCHAR(50) NOT NULL COMMENT '类型：purchase购买/recharge充值/refund退款',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '金额',
  `balance` DECIMAL(10,2) NOT NULL COMMENT '余额',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_type` (`type`),
  KEY `idx_created` (`created`),
  CONSTRAINT `fk_consumption_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_consumption_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消费记录表';

-- 17.设备操作记录表
DROP TABLE IF EXISTS `device_operation_logs`;
CREATE TABLE `device_operation_logs` (
  `id` INT UNSIGNED AUTO_INCREMENT COMMENT '记录ID',
  `admins_id` INT UNSIGNED NOT NULL COMMENT '所属管理者ID',
  `client_id` INT UNSIGNED NOT NULL COMMENT '操作用户ID',
  `device_id` INT UNSIGNED NOT NULL COMMENT '设备ID',
  `action` VARCHAR(100) NOT NULL COMMENT '操作类型',
  `result` VARCHAR(50) NOT NULL COMMENT '结果：success成功/failed失败',
  `detail` TEXT DEFAULT NULL COMMENT '详细信息JSON',
  `ip` VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created` (`created`),
  CONSTRAINT `fk_log_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_log_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备操作记录表';
