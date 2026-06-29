/*
 Navicat Premium Dump SQL

 Source Server         : tianji
 Source Server Type    : MySQL
 Source Server Version : 80029 (8.0.29)
 Source Host           : 192.168.150.101:3306
 Source Schema         : tj_remark

 Target Server Type    : MySQL
 Target Server Version : 80029 (8.0.29)
 File Encoding         : 65001

 Date: 26/06/2025 19:49:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for liked_record
-- ----------------------------
DROP TABLE IF EXISTS `liked_record`;
CREATE TABLE `liked_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `biz_id` bigint NOT NULL COMMENT '点赞的业务id',
  `biz_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '点赞的业务类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_biz_user`(`biz_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1717078498092888066 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '点赞记录表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 学习社区与共学 — 新增表（小组、帖子、笔记、打卡、挑战、敏感词）
-- ============================================================

-- ----------------------------
-- 1. study_group (学习小组)
-- ----------------------------
DROP TABLE IF EXISTS `study_group`;
CREATE TABLE `study_group` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL COMMENT '小组名称',
  `description` varchar(512) DEFAULT NULL COMMENT '小组简介',
  `course_id` bigint DEFAULT NULL COMMENT '关联课程ID（课程小组）或NULL（开放小组）',
  `creator_id` bigint NOT NULL COMMENT '创建者ID',
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '小组头像',
  `max_members` int NOT NULL DEFAULT 50 COMMENT '成员上限',
  `member_count` int NOT NULL DEFAULT 1 COMMENT '当前成员数',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-正常 1-已归档',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_creator_id` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习小组';

-- ----------------------------
-- 2. study_group_member (小组-成员)
-- ----------------------------
DROP TABLE IF EXISTS `study_group_member`;
CREATE TABLE `study_group_member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `role` tinyint NOT NULL DEFAULT 0 COMMENT '0-成员 1-管理员 2-组长',
  `join_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `study_days_this_week` int NOT NULL DEFAULT 0 COMMENT '本周学习天数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_user` (`group_id`, `user_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小组成员';

-- ----------------------------
-- 3. study_group_announcement (组内公告)
-- ----------------------------
DROP TABLE IF EXISTS `study_group_announcement`;
CREATE TABLE `study_group_announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` bigint NOT NULL,
  `author_id` bigint NOT NULL COMMENT '发布者ID',
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否置顶',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='组内公告';

-- ----------------------------
-- 4. community_post (社区帖子)
-- ----------------------------
DROP TABLE IF EXISTS `community_post`;
CREATE TABLE `community_post` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '作者ID',
  `title` varchar(255) NOT NULL COMMENT '帖子标题',
  `content` text NOT NULL COMMENT '帖子内容(Markdown)',
  `post_type` tinyint NOT NULL DEFAULT 1 COMMENT '类型: 1-讨论 2-笔记分享 3-问题求助 4-学习心得 5-资源推荐',
  `course_id` bigint DEFAULT NULL COMMENT '关联课程',
  `knowledge_ids` json DEFAULT NULL COMMENT '关联知识点ID列表',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览数',
  `like_count` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int NOT NULL DEFAULT 0 COMMENT '评论数',
  `is_essence` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否精华',
  `is_pinned` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否置顶',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '0-待审核 1-正常 2-已删除 3-审核驳回',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_post_type` (`post_type`),
  KEY `idx_create_time` (`create_time`),
  FULLTEXT KEY `ft_title_content` (`title`, `content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='社区帖子';

-- ----------------------------
-- 5. community_comment (评论/回复)
-- ----------------------------
DROP TABLE IF EXISTS `community_comment`;
CREATE TABLE `community_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '评论者ID',
  `parent_id` bigint DEFAULT 0 COMMENT '父评论ID（0=一级评论）',
  `reply_to_user_id` bigint DEFAULT NULL COMMENT '回复的目标用户ID',
  `content` varchar(2048) NOT NULL COMMENT '评论内容',
  `like_count` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '0-待审核 1-正常 2-已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='社区评论';

-- ----------------------------
-- 6. study_note (学习笔记)
-- ----------------------------
DROP TABLE IF EXISTS `study_note`;
CREATE TABLE `study_note` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '作者ID',
  `course_id` bigint DEFAULT NULL COMMENT '关联课程',
  `section_id` bigint DEFAULT NULL COMMENT '关联小节',
  `title` varchar(255) NOT NULL COMMENT '笔记标题',
  `content` text NOT NULL COMMENT '笔记内容(Markdown)',
  `visibility` tinyint NOT NULL DEFAULT 0 COMMENT '0-仅自己 1-组内可见 2-公开',
  `group_id` bigint DEFAULT NULL COMMENT '分享到的学习小组',
  `like_count` int NOT NULL DEFAULT 0,
  `bookmark_count` int NOT NULL DEFAULT 0 COMMENT '被收藏数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_course_section` (`course_id`, `section_id`),
  KEY `idx_visibility` (`visibility`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习笔记';

-- ----------------------------
-- 7. study_checkin (每日打卡)
-- ----------------------------
DROP TABLE IF EXISTS `study_checkin`;
CREATE TABLE `study_checkin` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `course_id` bigint DEFAULT NULL COMMENT '课程ID',
  `group_id` bigint DEFAULT NULL COMMENT '小组ID',
  `checkin_date` date NOT NULL COMMENT '打卡日期',
  `study_minutes` int NOT NULL DEFAULT 0 COMMENT '当日学习时长(分钟)',
  `completed_sections` int NOT NULL DEFAULT 0 COMMENT '完成小节数',
  `mood` tinyint DEFAULT NULL COMMENT '心情: 1-加油 2-开心 3-一般 4-疲惫',
  `note` varchar(512) DEFAULT NULL COMMENT '打卡备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_date` (`user_id`, `checkin_date`),
  KEY `idx_group_date` (`group_id`, `checkin_date`),
  KEY `idx_checkin_date` (`checkin_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='每日打卡';

-- ----------------------------
-- 8. study_challenge (共学挑战)
-- ----------------------------
DROP TABLE IF EXISTS `study_challenge`;
CREATE TABLE `study_challenge` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '挑战名称',
  `description` text COMMENT '挑战描述',
  `challenge_type` tinyint NOT NULL COMMENT '类型: 1-连续打卡 2-完课 3-做题量 4-学习时长',
  `target_value` int NOT NULL COMMENT '目标值（天数/题数/分钟数）',
  `course_id` bigint DEFAULT NULL COMMENT '限定课程',
  `group_id` bigint DEFAULT NULL COMMENT '限定小组（组内挑战）',
  `creator_id` bigint NOT NULL COMMENT '发起人',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `participant_count` int NOT NULL DEFAULT 0 COMMENT '参与人数',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-进行中 1-已结束 2-已取消',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`),
  KEY `idx_date_range` (`start_date`, `end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='共学挑战';

-- ----------------------------
-- 9. study_challenge_participant (挑战参与)
-- ----------------------------
DROP TABLE IF EXISTS `study_challenge_participant`;
CREATE TABLE `study_challenge_participant` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `challenge_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `current_progress` int NOT NULL DEFAULT 0 COMMENT '当前进度',
  `completed` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否完成',
  `completed_at` datetime DEFAULT NULL COMMENT '完成时间',
  `join_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_challenge_user` (`challenge_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='挑战参与者';

-- ----------------------------
-- 10. sensitive_word (敏感词库)
-- ----------------------------
DROP TABLE IF EXISTS `sensitive_word`;
CREATE TABLE `sensitive_word` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `word` varchar(64) NOT NULL COMMENT '敏感词',
  `level` tinyint NOT NULL DEFAULT 1 COMMENT '级别: 1-替代(**) 2-审核 3-拒绝',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_word` (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='敏感词库';

SET FOREIGN_KEY_CHECKS = 1;
