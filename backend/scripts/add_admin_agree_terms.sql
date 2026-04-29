-- 为管理端用户表添加同意用户协议和隐私政策字段
-- 执行时间：2026-04-29

USE device_flutter;

-- 添加 agree_terms 字段
ALTER TABLE admins 
ADD COLUMN agree_terms TINYINT(1) NOT NULL DEFAULT 0 
COMMENT '是否同意用户协议和隐私政策：0-未同意，1-已同意' 
AFTER status;

-- 更新现有管理员数据，设置为已同意
UPDATE admins SET agree_terms = 1;

-- 验证结果
SELECT id, username, agree_terms FROM admins;
