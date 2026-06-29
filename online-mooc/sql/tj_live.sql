/*
 在线直播互动增强 — 数据库表设计
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for live_room (直播间)
-- ----------------------------
DROP TABLE IF EXISTS `live_room`;
CREATE TABLE `live_room` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '直播间ID',
  `course_id` bigint NOT NULL COMMENT '关联课程ID',
  `section_id` bigint DEFAULT NULL COMMENT '关联小节ID',
  `teacher_id` bigint NOT NULL COMMENT '教师ID',
  `title` varchar(255) NOT NULL COMMENT '直播标题',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0-预约 1-直播中 2-已结束 3-已取消',
  `start_time` datetime NOT NULL COMMENT '计划开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '计划结束时间',
  `actual_start_time` datetime DEFAULT NULL COMMENT '实际开始时间',
  `actual_end_time` datetime DEFAULT NULL COMMENT '实际结束时间',
  `online_count` int NOT NULL DEFAULT 0 COMMENT '当前在线人数（Redis同步）',
  `total_view_count` int NOT NULL DEFAULT 0 COMMENT '累计观看人数',
  `replay_url` varchar(512) DEFAULT NULL COMMENT '回放地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播间';

-- ----------------------------
-- Table structure for live_interaction (互动消息记录 — 用于回放)
-- ----------------------------
DROP TABLE IF EXISTS `live_interaction`;
CREATE TABLE `live_interaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_id` bigint NOT NULL COMMENT '直播间ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `user_name` varchar(128) DEFAULT NULL COMMENT '用户名称（冗余，避免回放时查用户表）',
  `interaction_type` varchar(32) NOT NULL COMMENT '互动类型: danmaku/handraise/poll_vote/question/bookmark/like/pin',
  `content` text COMMENT '互动内容（弹幕文本/提问内容/标记备注等）',
  `payload` json DEFAULT NULL COMMENT '扩展数据（投票选项/举手状态等）',
  `timestamp_ms` bigint NOT NULL COMMENT '直播内相对时间戳(ms)，从直播开始计时',
  `is_censored` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否被屏蔽',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_time` (`room_id`, `timestamp_ms`),
  KEY `idx_room_type` (`room_id`, `interaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播互动消息记录';

-- ----------------------------
-- Table structure for live_poll (投票)
-- ----------------------------
DROP TABLE IF EXISTS `live_poll`;
CREATE TABLE `live_poll` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '投票ID',
  `room_id` bigint NOT NULL COMMENT '直播间ID',
  `teacher_id` bigint NOT NULL COMMENT '发起教师ID',
  `title` varchar(512) NOT NULL COMMENT '投票标题',
  `options` json NOT NULL COMMENT '选项列表 [{"id":1,"text":"选项A"},...]',
  `is_multiple` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否多选',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0-未开始 1-进行中 2-已结束',
  `total_votes` int NOT NULL DEFAULT 0 COMMENT '总投票数',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_id` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播投票';

-- ----------------------------
-- Table structure for live_poll_vote (投票记录)
-- ----------------------------
DROP TABLE IF EXISTS `live_poll_vote`;
CREATE TABLE `live_poll_vote` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `poll_id` bigint NOT NULL COMMENT '投票ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `option_ids` json NOT NULL COMMENT '选择的选项ID列表',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_poll_user` (`poll_id`, `user_id`),
  KEY `idx_poll_id` (`poll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='投票记录';

-- ----------------------------
-- Table structure for live_question (课堂提问)
-- ----------------------------
DROP TABLE IF EXISTS `live_question`;
CREATE TABLE `live_question` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提问ID',
  `room_id` bigint NOT NULL COMMENT '直播间ID',
  `user_id` bigint NOT NULL COMMENT '提问用户ID',
  `user_name` varchar(128) DEFAULT NULL COMMENT '用户名称',
  `content` varchar(1024) NOT NULL COMMENT '提问内容',
  `reply_content` varchar(1024) DEFAULT NULL COMMENT '教师回复内容',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0-待回复 1-已回复 2-已忽略 3-已置顶',
  `pinned_at` datetime DEFAULT NULL COMMENT '置顶时间',
  `timestamp_ms` bigint NOT NULL COMMENT '直播内时间戳(ms)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_status` (`room_id`, `status`),
  KEY `idx_room_time` (`room_id`, `timestamp_ms`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播课堂提问';

-- ----------------------------
-- Table structure for live_bookmark (重点标记)
-- ----------------------------
DROP TABLE IF EXISTS `live_bookmark`;
CREATE TABLE `live_bookmark` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标记ID',
  `room_id` bigint NOT NULL COMMENT '直播间ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（学生个人标记）或教师ID（全局重点）',
  `scope` tinyint NOT NULL DEFAULT 0 COMMENT '范围: 0-个人 1-全局（教师标记，全员可见）',
  `label` varchar(128) DEFAULT NULL COMMENT '标记标签',
  `note` varchar(512) DEFAULT NULL COMMENT '标记备注',
  `timestamp_ms` bigint NOT NULL COMMENT '直播内时间戳(ms)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_user` (`room_id`, `user_id`),
  KEY `idx_room_scope` (`room_id`, `scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='直播重点标记';

SET FOREIGN_KEY_CHECKS = 1;
