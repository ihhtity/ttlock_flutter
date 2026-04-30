-- 优化用户表结构
-- 执行时间：2026-04-30

-- 1. 管理端用户表（admins）添加 country 和 dial_code 字段
ALTER TABLE `admins` 
ADD COLUMN `country` VARCHAR(10) DEFAULT 'CN' COMMENT '国家代码' AFTER `avatar`,
ADD COLUMN `dial_code` VARCHAR(10) DEFAULT '+86' COMMENT '电话区号' AFTER `country`;

-- 2. 用户端用户表（clients）删除不需要的字段
ALTER TABLE `clients` 
DROP COLUMN `phone_bound`,
DROP COLUMN `email_bound`,
DROP COLUMN `is_vendor`;
