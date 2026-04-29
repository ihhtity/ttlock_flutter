-- ============================================
-- 设备管理系统 - 测试数据插入脚本
-- 数据库：device_flutter
-- 创建时间: 2026-04-29
-- 说明：根据 Flutter 页面模拟数据生成的测试记录
-- ============================================

USE device_flutter;

-- ============================================
-- 0. 清理旧测试数据 (按外键依赖顺序删除)
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `device_operation_logs`;
TRUNCATE TABLE `consumption_records`;
TRUNCATE TABLE `device_transfer_logs`;
TRUNCATE TABLE `help_feedback`;
TRUNCATE TABLE `user_settings`;
TRUNCATE TABLE `family_members`;
TRUNCATE TABLE `messages`;
TRUNCATE TABLE `orders`;
TRUNCATE TABLE `payment_accounts`;
TRUNCATE TABLE `sub_accounts`;
TRUNCATE TABLE `vendors`;
TRUNCATE TABLE `device_rules`;
TRUNCATE TABLE `device_groups`;
TRUNCATE TABLE `devices`;
TRUNCATE TABLE `rooms`;
TRUNCATE TABLE `clients`;
TRUNCATE TABLE `admins`;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. 管理端用户 (admins)
-- ============================================
INSERT INTO `admins` (`username`, `password`, `real_name`, `phone`, `email`, `role`, `status`) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '超级管理员', '13800138000', 'admin@ttlock.com', 1, 1),
('operator', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '运维人员', '13800138001', 'op@ttlock.com', 3, 1),
('19830357494', '$2a$10$wXzW5Q5Q5Q5Q5Q5Q5Q5Q5O5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q', '测试管理员', '19830357494', 'test_admin@ttlock.com', 1, 1);

-- ============================================
-- 2. 用户端用户 (clients)
-- ============================================
-- 假设 admin (id=1) 是这些用户的所属管理者
INSERT INTO `clients` (`admins_id`, `phone`, `email`, `password`, `nickname`, `country`, `dial_code`, `agree_terms`, `phone_bound`, `is_vendor`, `status`) VALUES
(1, '19830357494', 'user1@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '张三', 'CN', '+86', 1, 1, 0, 1),
(1, '13900139000', 'user2@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '李四', 'CN', '+86', 1, 1, 0, 1),
(1, '13700137000', 'vendor1@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '厂商代表', 'CN', '+86', 1, 1, 1, 1);

-- ============================================
-- 3. 房间数据 (rooms) - 关联 client_id = 1 (张三)
-- ============================================
INSERT INTO `rooms` (`admins_id`, `client_id`, `name`, `type`, `building`, `floor`, `status`, `battery`, `devices`, `lock_mac`) VALUES
(1, 1, '101', '标准间', 'A栋', 1, 'vacant', 85, '["lock", "light"]', 'AA:BB:CC:DD:EE:01'),
(1, 1, '102', '大床房', 'A栋', 1, 'rented', 72, '["lock", "light", "ac"]', 'AA:BB:CC:DD:EE:02'),
(1, 1, '103', '双床房', 'A栋', 1, 'maintenance', 45, '["lock"]', 'AA:BB:CC:DD:EE:03'),
(1, 1, '201', '标准间', 'A栋', 2, 'vacant', 90, '["lock", "light"]', 'AA:BB:CC:DD:EE:04'),
(1, 1, '202', '套房', 'A栋', 2, 'rented', 100, '["lock", "light", "ac", "tv"]', 'AA:BB:CC:DD:EE:05'),
(1, 1, '301', '豪华套房', 'B栋', 3, 'rented', 88, '["lock", "light", "ac", "tv"]', 'AA:BB:CC:DD:EE:06');

-- ============================================
-- 4. 设备分组 (device_groups) - 关联 client_id = 1
-- ============================================
INSERT INTO `device_groups` (`admins_id`, `client_id`, `name`, `icon`, `color`, `sort`) VALUES
(1, 1, '门锁设备', 'lock_rounded', '#2196F3', 1),
(1, 1, '传感器', 'sensors_rounded', '#4CAF50', 2),
(1, 1, '网关设备', 'router_rounded', '#FF9800', 3),
(1, 1, '摄像头', 'camera_alt_rounded', '#9C27B0', 4);

-- ============================================
-- 5. 设备数据 (devices) - 关联 client_id = 1
-- ============================================
-- 智能锁
INSERT INTO `devices` (`admins_id`, `client_id`, `room_id`, `group_id`, `name`, `type`, `mac`, `model`, `status`, `battery`, `data`) VALUES
(1, 1, 1, 1, '101大门智能锁', 'lock', 'AA:BB:CC:DD:EE:01', 'TTLock Pro', 1, 85, '{"location": "前门"}'),
(1, 1, 2, 1, '102卧室门锁', 'lock', 'AA:BB:CC:DD:EE:02', 'TTLock Lite', 1, 72, '{"location": "主卧"}'),
(1, 1, NULL, 1, '办公室门禁', 'lock', 'AA:BB:CC:DD:EE:03', 'TTLock Business', 1, 90, '{"location": "办公室"}'),
(1, 1, NULL, 1, '书房门锁', 'lock', 'AA:BB:CC:DD:EE:04', 'TTLock Standard', 0, 5, '{"location": "书房"}');

-- 网关
INSERT INTO `devices` (`admins_id`, `client_id`, `room_id`, `group_id`, `name`, `type`, `mac`, `model`, `status`, `battery`, `data`) VALUES
(1, 1, NULL, 3, '客厅网关', 'gateway', 'GG:HH:II:JJ:KK:01', 'TTLock Gateway', 1, 100, '{"location": "客厅", "lockCount": 3}'),
(1, 1, NULL, 3, '车库网关', 'gateway', 'GG:HH:II:JJ:KK:02', 'TTLock Gateway Pro', 0, 45, '{"location": "车库", "lockCount": 1}');

-- 电源
INSERT INTO `devices` (`admins_id`, `client_id`, `room_id`, `group_id`, `name`, `type`, `mac`, `model`, `status`, `battery`, `data`) VALUES
(1, 1, NULL, NULL, '客厅电源控制器', 'power', 'PP:QQ:RR:SS:TT:01', 'TTLock Power', 1, 88, '{"location": "客厅", "powerStatus": "on"}'),
(1, 1, NULL, NULL, '餐厅电源控制', 'power', 'PP:QQ:RR:SS:TT:02', 'TTLock Power Pro', 0, 22, '{"location": "餐厅", "powerStatus": "offline"}');

-- ============================================
-- 6. 个人设置 (user_settings)
-- ============================================
-- 管理员设置 (client_id 为 NULL)
INSERT INTO `user_settings` (`admins_id`, `client_id`, `key`, `value`) VALUES
(1, NULL, 'theme_mode', 'dark'),
(1, NULL, 'dashboard_layout', 'grid');

-- 用户设置 (client_id = 1)
INSERT INTO `user_settings` (`admins_id`, `client_id`, `key`, `value`) VALUES
(1, 1, 'language', 'zh-CN'),
(1, 1, 'notification_sound', 'true'),
(1, 1, 'auto_lock_time', '30');

-- ============================================
-- 7. 消息通知 (messages) - 关联 client_id = 1
-- ============================================
INSERT INTO `messages` (`admins_id`, `client_id`, `type`, `title`, `content`, `is_read`, `created`) VALUES
(1, 1, 'device', '低电量提醒', '您的设备“书房门锁”电量已低于 10%，请及时更换电池。', 0, NOW()),
(1, 1, 'system', '系统维护通知', '系统将于今晚 23:00 进行例行维护，预计耗时 30 分钟。', 1, DATE_SUB(NOW(), INTERVAL 1 DAY));

-- ============================================
-- 8. 帮助反馈 (help_feedback) - 关联 client_id = 1
-- ============================================
INSERT INTO `help_feedback` (`admins_id`, `client_id`, `type`, `title`, `content`, `status`) VALUES
(1, 1, 'bug', 'App 闪退问题', '在设备管理页面点击刷新时偶尔会闪退。', 'pending');

-- ============================================
-- 9. 厂商表 (vendors)
-- ============================================
INSERT INTO `vendors` (`admins_id`, `client_id`, `name`, `code`, `contact`, `phone`, `email`, `address`, `status`) VALUES
(1, NULL, '智能锁具科技', 'VENDOR_001', '王经理', '13600136000', 'wang@smartlock.com', '深圳市南山区科技园', 1),
(1, NULL, '网关设备制造', 'VENDOR_002', '李总', '13500135000', 'li@gateway.com', '广州市天河区软件园', 1);

-- ============================================
-- 10. 子账号表 (sub_accounts)
-- ============================================
INSERT INTO `sub_accounts` (`admins_id`, `username`, `password`, `nickname`, `phone`, `role`, `permissions`, `status`) VALUES
(1, 'sub_user1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '小王', '13400134000', 'user', '["view_rooms", "manage_devices"]', 1),
(1, 'sub_user2', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '小李', '13300133000', 'viewer', '["view_only"]', 1);

-- ============================================
-- 11. 收款账号表 (payment_accounts)
-- ============================================
INSERT INTO `payment_accounts` (`admins_id`, `client_id`, `type`, `name`, `account`, `real_name`, `is_default`, `status`) VALUES
(1, 1, 'wechat', '微信支付-张三', 'wxid_zhangsan123', '张三', 1, 1),
(1, 1, 'alipay', '支付宝-张三', 'zhangsan@alipay.com', '张三', 0, 1),
(1, 1, 'bank', '工商银行储蓄卡', '6222021234567890123', '张三', 0, 1);

-- ============================================
-- 12. 订单表 (orders) - 必须在消费记录之前插入
-- ============================================
INSERT INTO `orders` (`order_no`, `admins_id`, `client_id`, `title`, `amount`, `status`, `pay_type`, `pay_time`, `remark`) VALUES
('ORD202604290001', 1, 1, '购买智能门锁 S300', 1299.00, 'completed', 'wechat', DATE_SUB(NOW(), INTERVAL 2 DAY), '首单优惠'),
('ORD202604290002', 1, 1, '网关 G200 续费一年', 199.00, 'pending', NULL, NULL, '自动续费待支付'),
('ORD202604290003', 1, 2, '批量采购电源控制器 x5', 850.00, 'completed', 'alipay', DATE_SUB(NOW(), INTERVAL 5 DAY), NULL);

-- ============================================
-- 13. 家庭成员表 (family_members)
-- ============================================
INSERT INTO `family_members` (`admins_id`, `client_id`, `name`, `phone`, `relation`, `avatar`, `permissions`, `status`) VALUES
(1, 1, '王芳', '13200132000', '妻子', 'https://example.com/avatar/wangfang.jpg', '["unlock", "view_logs"]', 1),
(1, 1, '张小明', '13100131000', '儿子', 'https://example.com/avatar/zhangxm.jpg', '["unlock"]', 1),
(1, 1, '张大爷', '13000130000', '父亲', NULL, '["unlock", "emergency_call"]', 1);

-- ============================================
-- 14. 消费记录表 (consumption_records) - 关联已存在的订单
-- ============================================
INSERT INTO `consumption_records` (`admins_id`, `client_id`, `order_id`, `type`, `amount`, `balance`, `remark`) VALUES
(1, 1, 1, 'purchase', -1299.00, 8701.00, '购买智能门锁'),
(1, 1, NULL, 'recharge', 5000.00, 10000.00, '账户充值'),
(1, 1, 2, 'purchase', -199.00, 9801.00, '网关服务续费');

-- ============================================
-- 15. 设备操作记录表 (device_operation_logs)
-- ============================================
INSERT INTO `device_operation_logs` (`admins_id`, `client_id`, `device_id`, `action`, `result`, `detail`, `ip`) VALUES
(1, 1, 1, 'remote_unlock', 'success', '{"method": "app", "time": "2026-04-29 10:30:00"}', '192.168.1.100'),
(1, 1, 2, 'change_password', 'success', '{"key_type": "passcode"}', '192.168.1.101'),
(1, 1, 5, 'gateway_reboot', 'failed', '{"error": "timeout"}', '192.168.1.102');

-- ============================================
-- 16. 设备规则表 (device_rules)
-- ============================================
INSERT INTO `device_rules` (`admins_id`, `client_id`, `device_id`, `name`, `type`, `trigger`, `action`, `enabled`) VALUES
(1, 1, 1, '夜间自动布防', 'schedule', '{"time": "23:00", "repeat": ["mon", "tue", "wed", "thu", "fri"]}', '{"action": "lock"}', 1),
(1, 1, NULL, '离家模式', 'automation', '{"condition": "all_members_leave"}', '{"action": "lock_all", "turn_off_lights": true}', 1);

-- ============================================
-- 17. 设备转移记录表 (device_transfer_logs)
-- ============================================
INSERT INTO `device_transfer_logs` (`device_id`, `from_admins_id`, `to_admins_id`, `reason`, `status`, `created`, `completed`) VALUES
(3, 1, 1, '员工离职交接', 'completed', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 9 DAY));