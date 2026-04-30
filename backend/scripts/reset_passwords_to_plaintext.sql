-- 将所有管理员和用户密码重置为明文（仅用于开发调试）
-- ⚠️ 警告：此操作仅用于开发环境，生产环境严禁使用明文密码！

USE device_flutter;

-- 重置管理员密码为明文
UPDATE admins SET password = '123456' WHERE username = 'admin';
UPDATE admins SET password = 'admin123' WHERE username = 'operator';

-- 重置所有用户密码为明文（根据手机号或邮箱识别）
UPDATE clients SET password = '19830357494a.' WHERE phone = '19830357494';
UPDATE clients SET password = '123456' WHERE phone = '13800138000';
UPDATE clients SET password = '123456' WHERE phone = '13900139000';
UPDATE clients SET password = '123456' WHERE phone = '13700137000';
UPDATE clients SET password = 'test123456' WHERE email = 'ihhtity@qq.com';
UPDATE clients SET password = 'user1@test.com' WHERE email = 'user1@test.com';
UPDATE clients SET password = 'user2@test.com' WHERE email = 'user2@test.com';
UPDATE clients SET password = 'vendor1@test.com' WHERE email = 'vendor1@test.com';

-- 验证更新结果
SELECT id, username, phone, email, password FROM admins;
SELECT id, phone, email, nickname, password FROM clients;
