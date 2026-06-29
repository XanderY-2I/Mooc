/*
 Navicat Premium Dump SQL

 Source Server         : tianji
 Source Server Type    : MySQL
 Source Server Version : 80029 (8.0.29)
 Source Host           : 192.168.150.101:3306
 Source Schema         : tj_chat

 Target Server Type    : MySQL
 Target Server Version : 80029 (8.0.29)
 File Encoding         : 65001

 Date: 26/06/2025 19:48:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chat_session
-- ----------------------------
DROP TABLE IF EXISTS `chat_session`;
CREATE TABLE `chat_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话ID',
  `segment_index` int NOT NULL COMMENT '会话片段序号，从0开始',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息内容，JSON格式，包含role、type、text等',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '插入时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_session`(`user_id` ASC, `session_id` ASC) USING BTREE COMMENT '用户和会话的联合索引'
) ENGINE = InnoDB AUTO_INCREMENT = 1938117539503099907 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '聊天对话的每个片段记录（分片存储）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_markdown_docs
-- ----------------------------
DROP TABLE IF EXISTS `user_markdown_docs`;
CREATE TABLE `user_markdown_docs`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `user_id` bigint NOT NULL COMMENT '上传用户ID',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '上传时的原始文件名',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '整个 Markdown 文本内容',
  `create_time` datetime NOT NULL COMMENT '上传时间',
  `update_time` datetime NOT NULL COMMENT '最近更新时间',
  `level` int NOT NULL COMMENT '文档切割等级',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE COMMENT '用户ID索引'
) ENGINE = InnoDB AUTO_INCREMENT = 1935242243233931266 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户上传的 Markdown 文档表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_session
-- ----------------------------
DROP TABLE IF EXISTS `user_session`;
CREATE TABLE `user_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE COMMENT '用户与会话关联表'
) ENGINE = InnoDB AUTO_INCREMENT = 1931702636819091458 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ai_conversation (AI助手对话历史)
-- ----------------------------
DROP TABLE IF EXISTS `ai_conversation`;
CREATE TABLE `ai_conversation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_id` varchar(64) NOT NULL COMMENT '会话ID，UUID格式',
  `conversation_type` tinyint NOT NULL COMMENT '对话类型：1-课程问答,2-知识点总结,3-错题讲解,4-练习题生成,5-学习路径',
  `course_id` bigint DEFAULT NULL COMMENT '关联课程ID',
  `section_id` bigint DEFAULT NULL COMMENT '关联小节ID',
  `question` text NOT NULL COMMENT '用户提问原文',
  `answer` mediumtext NOT NULL COMMENT 'AI回答内容',
  `sources` json DEFAULT NULL COMMENT '引用来源，JSON数组 [{docId,title,excerpt}]',
  `prompt_tokens` int DEFAULT 0 COMMENT '消耗的prompt token数',
  `completion_tokens` int DEFAULT 0 COMMENT '消耗的completion token数',
  `rating` tinyint DEFAULT NULL COMMENT '用户评分 1-5',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_session` (`user_id`, `session_id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_type` (`conversation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI助手对话历史';

-- ----------------------------
-- Table structure for ai_knowledge_chunk (知识库分段索引)
-- ----------------------------
DROP TABLE IF EXISTS `ai_knowledge_chunk`;
CREATE TABLE `ai_knowledge_chunk` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `doc_id` varchar(128) NOT NULL COMMENT '来源文档标识，格式: {type}:{id}，如 course:1001, video:subtitle:2001',
  `course_id` bigint NOT NULL COMMENT '所属课程ID',
  `section_id` bigint DEFAULT NULL COMMENT '所属小节ID（讲义/字幕关联）',
  `content_type` tinyint NOT NULL COMMENT '内容类型：1-课程介绍,2-讲义,3-视频字幕,4-PDF文档,5-题目,6-评论精华',
  `chunk_index` int NOT NULL COMMENT '分段序号',
  `title` varchar(512) DEFAULT NULL COMMENT '分段标题/摘要',
  `content` text NOT NULL COMMENT '分段文本内容',
  `qdrant_point_id` char(36) DEFAULT NULL COMMENT 'Qdrant中对应的point ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_doc_id` (`doc_id`),
  KEY `idx_course_section` (`course_id`, `section_id`),
  KEY `idx_content_type` (`content_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI知识库文本分段索引（元数据存储）';

-- ----------------------------
-- Table structure for ai_exercise (AI生成的练习题)
-- ----------------------------
DROP TABLE IF EXISTS `ai_exercise`;
CREATE TABLE `ai_exercise` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '生成此练习的用户ID（教师/学生）',
  `course_id` bigint NOT NULL COMMENT '关联课程ID',
  `section_id` bigint DEFAULT NULL COMMENT '关联小节ID',
  `session_id` varchar(64) DEFAULT NULL COMMENT '关联对话会话ID',
  `exercise_type` tinyint NOT NULL COMMENT '题目类型：1-单选,2-多选,3-判断,4-填空,5-简答',
  `difficulty` tinyint NOT NULL DEFAULT 2 COMMENT '难度：1-简单,2-中等,3-困难',
  `question` text NOT NULL COMMENT '题目内容',
  `options` json DEFAULT NULL COMMENT '选项JSON（选择题）',
  `answer` varchar(1024) DEFAULT NULL COMMENT '正确答案',
  `analysis` text COMMENT '答案解析',
  `knowledge_point` varchar(512) DEFAULT NULL COMMENT '考察知识点',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_course` (`user_id`, `course_id`),
  KEY `idx_session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI生成的练习题';

-- ----------------------------
-- Table structure for ai_learning_path (学习路径推荐记录)
-- ----------------------------
DROP TABLE IF EXISTS `ai_learning_path`;
CREATE TABLE `ai_learning_path` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_id` varchar(64) DEFAULT NULL COMMENT '关联会话ID',
  `suggestion` mediumtext NOT NULL COMMENT '学习路径建议全文（Markdown）',
  `recommended_courses` json DEFAULT NULL COMMENT '推荐课程ID列表 [1001, 1002]',
  `weak_points` json DEFAULT NULL COMMENT '薄弱知识点列表 ["Java多线程", "JVM调优"]',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI学习路径推荐记录';

SET FOREIGN_KEY_CHECKS = 1;
