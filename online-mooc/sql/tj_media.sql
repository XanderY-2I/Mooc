/*
 Navicat Premium Dump SQL

 Source Server         : tianji
 Source Server Type    : MySQL
 Source Server Version : 80029 (8.0.29)
 Source Host           : 192.168.150.101:3306
 Source Schema         : tj_media

 Target Server Type    : MySQL
 Target Server Version : 80029 (8.0.29)
 File Encoding         : 65001

 Date: 26/06/2025 19:49:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for file
-- ----------------------------
DROP TABLE IF EXISTS `file`;
CREATE TABLE `file`  (
  `id` bigint NOT NULL COMMENT '主键，文件id',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件在云端的唯一标示，例如：aaa.jpg',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件上传时的名称',
  `request_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求id',
  `file_hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件内容哈希值（用于秒传）',
  `file_size` bigint NULL DEFAULT 0 COMMENT '文件大小（字节）',
  `file_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件类型/MIME类型',
  `bucket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'tianji' COMMENT '存储桶名称',
  `use_times` int NULL DEFAULT 0 COMMENT '被引用次数',
  `status` tinyint NOT NULL COMMENT '状态：1-上传中 2-已上传 3-已处理',
  `platform` tinyint NULL DEFAULT 1 COMMENT '平台：1-腾讯，2-阿里 3-Minio',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creater` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updater` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `dep_id` bigint NOT NULL DEFAULT 0 COMMENT '部门id',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除，默认0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文件表，可以是普通文件、图片等' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for file_chunk_upload
-- ----------------------------
DROP TABLE IF EXISTS `file_chunk_upload`;
CREATE TABLE `file_chunk_upload`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_id` bigint NOT NULL COMMENT '关联的文件ID',
  `upload_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MinIO分片上传ID',
  `chunk_count` int NOT NULL COMMENT '总分片数',
  `chunk_size` int NOT NULL COMMENT '分片大小(字节)',
  `completed_chunks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '已上传完成的分片序号列表(JSON数组)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_file`(`file_id` ASC) USING BTREE,
  INDEX `idx_upload`(`upload_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '分片上传记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for media
-- ----------------------------
DROP TABLE IF EXISTS `media`;
CREATE TABLE `media`  (
  `id` bigint NOT NULL COMMENT '主键',
  `file_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件在云端的唯一标示，例如：387702302659783576',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件名称',
  `media_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '媒体播放地址',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '媒体封面地址',
  `duration` double NOT NULL DEFAULT 0 COMMENT '视频时长，单位秒',
  `size` bigint NOT NULL DEFAULT 0 COMMENT '视频大小，单位是字节',
  `request_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求id',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-上传中，2-已上传',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creater` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updater` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `dep_id` bigint NOT NULL DEFAULT 0 COMMENT '部门id',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除，默认0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '媒资表，主要是视频文件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for media_file
-- ----------------------------
DROP TABLE IF EXISTS `media_file`;
CREATE TABLE `media_file`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原始文件名',
  `file_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MinIO存储key(唯一标识)',
  `file_hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件内容哈希值(用于秒传)',
  `file_size` bigint NOT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件类型',
  `bucket_name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MinIO桶名称',
  `upload_status` tinyint NOT NULL DEFAULT 0 COMMENT '0-未上传 1-上传中 2-上传完成 3-上传失败',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `file_key`(`file_key` ASC) USING BTREE,
  INDEX `idx_hash`(`file_hash` ASC) USING BTREE,
  INDEX `idx_status`(`upload_status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文件信息表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 视频体验优化 — 新增表
-- ============================================================

DROP TABLE IF EXISTS `video_playback_state`;
CREATE TABLE `video_playback_state` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `media_id` bigint NOT NULL COMMENT '媒资ID',
  `course_id` bigint DEFAULT NULL COMMENT '课程ID',
  `section_id` bigint DEFAULT NULL COMMENT '小节ID',
  `current_position` int NOT NULL DEFAULT 0 COMMENT '当前播放位置(秒)',
  `total_duration` int NOT NULL DEFAULT 0 COMMENT '视频总时长(秒)',
  `playback_rate` decimal(3,1) NOT NULL DEFAULT 1.0 COMMENT '倍速: 0.5/0.75/1.0/1.25/1.5/2.0',
  `quality_level` varchar(16) NOT NULL DEFAULT 'auto' COMMENT '清晰度: auto/360p/480p/720p/1080p',
  `volume` tinyint NOT NULL DEFAULT 80 COMMENT '音量 0-100',
  `subtitle_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '字幕开关',
  `subtitle_lang` varchar(8) DEFAULT 'zh' COMMENT '字幕语言',
  `last_heartbeat` datetime NOT NULL COMMENT '最后心跳',
  `completed` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已完成',
  `completion_pct` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT '完成百分比',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_media` (`user_id`, `media_id`),
  KEY `idx_last_heartbeat` (`last_heartbeat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='视频播放状态（断点续播/倍速记忆/清晰度记忆）';

DROP TABLE IF EXISTS `video_quality_track`;
CREATE TABLE `video_quality_track` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `media_id` bigint NOT NULL COMMENT '媒资ID',
  `quality_level` varchar(16) NOT NULL COMMENT '清晰度',
  `bitrate_kbps` int NOT NULL COMMENT '码率(kbps)',
  `file_url` varchar(512) NOT NULL COMMENT '转码后URL',
  `file_size` bigint DEFAULT NULL COMMENT '字节数',
  `width` int DEFAULT NULL COMMENT '宽',
  `height` int DEFAULT NULL COMMENT '高',
  `codec` varchar(32) DEFAULT 'h264' COMMENT '编码',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认',
  `transcode_status` tinyint NOT NULL DEFAULT 1 COMMENT '1-处理中 2-完成 3-失败',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_media_quality` (`media_id`, `quality_level`),
  KEY `idx_media_id` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='视频多清晰度轨道';

DROP TABLE IF EXISTS `video_preload_hint`;
CREATE TABLE `video_preload_hint` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `from_section_id` bigint NOT NULL COMMENT '当前小节',
  `to_section_id` bigint NOT NULL COMMENT '预加载目标小节',
  `priority` tinyint NOT NULL DEFAULT 0 COMMENT '0-下一节 1-薄弱点 2-教师推荐',
  `reason` varchar(128) DEFAULT NULL COMMENT '预加载原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_from` (`course_id`, `from_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='视频预加载提示';

DROP TABLE IF EXISTS `video_network_log`;
CREATE TABLE `video_network_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `media_id` bigint NOT NULL COMMENT '媒资ID',
  `network_type` varchar(16) DEFAULT NULL COMMENT 'wifi/4g/5g/wired',
  `effective_bandwidth_kbps` int DEFAULT NULL COMMENT '实测带宽',
  `buffering_count` int NOT NULL DEFAULT 0 COMMENT '卡顿次数',
  `buffering_duration_ms` int NOT NULL DEFAULT 0 COMMENT '累计卡顿时长ms',
  `avg_bitrate_kbps` int DEFAULT NULL COMMENT '实际平均码率',
  `switch_from_quality` varchar(16) DEFAULT NULL COMMENT '切换前清晰度',
  `switch_to_quality` varchar(16) DEFAULT NULL COMMENT '切换后清晰度',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_media` (`user_id`, `media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='弱网诊断日志';

SET FOREIGN_KEY_CHECKS = 1;
