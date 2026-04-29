-- TTLock Backend 数据库初始化脚本
-- 如果表已存在则先删除

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 管理员表
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
  `created` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ----------------------------
-- 2. 客户端用户表
-- ----------------------------
DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admins_id` int(11) NOT NULL COMMENT '所属管理员ID',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `country` varchar(10) DEFAULT 'CN' COMMENT '国家',
  `dial_code` varchar(10) DEFAULT '+86' COMMENT '区号',
  `agree_terms` tinyint(1) DEFAULT '0' COMMENT '是否同意条款',
  `phone_bound` tinyint(1) DEFAULT '0' COMMENT '手机是否绑定',
  `email_bound` tinyint(1) DEFAULT '0' COMMENT '邮箱是否绑定',
  `is_vendor` tinyint(1) DEFAULT '0' COMMENT '是否厂商',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1-正常，0-禁用',
  `last_login` datetime DEFAULT NULL COMMENT '最后登录时间',
  `created` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_admins_id` (`admins_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户端用户表';

-- ----------------------------
-- 3. 房间表
-- ----------------------------
DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admins_id` int(11) NOT NULL COMMENT '所属管理员ID',
  `client_id` int(11) NOT NULL COMMENT '所属用户ID',
  `name` varchar(50) NOT NULL COMMENT '房间名称',
  `type` varchar(50) DEFAULT NULL COMMENT '房间类型',
  `building` varchar(50) DEFAULT NULL COMMENT '楼栋',
  `floor` int(11) DEFAULT NULL COMMENT '楼层',
  `status` varchar(20) DEFAULT 'vacant' COMMENT '状态：vacant-空置，rented-已租',
  `battery` int(11) DEFAULT '100' COMMENT '电量',
  `devices` json DEFAULT NULL COMMENT '设备列表',
  `lock_data` json DEFAULT NULL COMMENT '锁数据',
  `lock_mac` varchar(50) DEFAULT NULL COMMENT '锁MAC地址',
  `created` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房间表';

-- ----------------------------
-- 4. 设备分组表
-- ----------------------------
DROP TABLE IF EXISTS `device_groups`;
CREATE TABLE `device_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admins_id` int(11) NOT NULL COMMENT '所属管理员ID',
  `client_id` int(11) NOT NULL COMMENT '所属用户ID',
  `name` varchar(100) NOT NULL COMMENT '分组名称',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标',
  `color` varchar(20) DEFAULT NULL COMMENT '颜色',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `created` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备分组表';

-- ----------------------------
-- 5. 设备表
-- ----------------------------
DROP TABLE IF EXISTS `devices`;
CREATE TABLE `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admins_id` int(11) NOT NULL COMMENT '所属管理员ID',
  `client_id` int(11) NOT NULL COMMENT '所属用户ID',
  `room_id` int(11) DEFAULT NULL COMMENT '关联房间ID',
  `group_id` int(11) DEFAULT NULL COMMENT '关联分组ID',
  `name` varchar(100) NOT NULL COMMENT '设备名称',
  `type` varchar(50) NOT NULL COMMENT '设备类型：lock-门锁，gateway-网关',
  `mac` varchar(50) NOT NULL COMMENT 'MAC地址',
  `model` varchar(100) DEFAULT NULL COMMENT '型号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1-在线，0-离线',
  `battery` int(11) DEFAULT '100' COMMENT '电量百分比',
  `firmware` varchar(50) DEFAULT NULL COMMENT '固件版本',
  `data` json DEFAULT NULL COMMENT '设备数据',
  `last_online` datetime DEFAULT NULL COMMENT '最后在线时间',
  `created` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mac` (`mac`),
  KEY `idx_admins_id` (`admins_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_room_id` (`room_id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备表';

-- ----------------------------
-- 插入测试数据
-- ----------------------------

-- 插入管理员
INSERT INTO `admins` (`username`, `password`, `email`, `phone`, `status`) 
VALUES ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'admin@ttlock.com', '13800000000', 1);

-- 插入测试用户（密码: 123456）
INSERT INTO `clients` (`admins_id`, `phone`, `password`, `nickname`, `status`) 
VALUES (1, '13800138000', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '张三', 1);

-- 插入测试房间
INSERT INTO `rooms` (`admins_id`, `client_id`, `name`, `type`, `building`, `floor`, `status`) 
VALUES 
(1, 1, '101', '标准间', 'A栋', 1, 'vacant'),
(1, 1, '102', '标准间', 'A栋', 1, 'vacant'),
(1, 1, '201', '豪华间', 'A栋', 2, 'rented');

-- 插入测试设备分组
INSERT INTO `device_groups` (`admins_id`, `client_id`, `name`, `icon`, `color`, `sort`) 
VALUES 
(1, 1, '门锁设备', 'lock_rounded', '#2196F3', 1),
(1, 1, '网关设备', 'router', '#4CAF50', 2);

-- 插入测试设备
INSERT INTO `devices` (`admins_id`, `client_id`, `room_id`, `group_id`, `name`, `type`, `mac`, `model`, `status`, `battery`) 
VALUES 
(1, 1, 1, 1, '101大门智能锁', 'lock', 'AA:BB:CC:DD:EE:01', 'TTLock Pro', 1, 85),
(1, 1, 2, 1, '102大门智能锁', 'lock', 'AA:BB:CC:DD:EE:02', 'TTLock Pro', 1, 90),
(1, 1, 3, 1, '201大门智能锁', 'lock', 'AA:BB:CC:DD:EE:03', 'TTLock Pro', 0, 45);

SET FOREIGN_KEY_CHECKS = 1;
