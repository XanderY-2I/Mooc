/*
 Navicat Premium Dump SQL

 Source Server         : tianji
 Source Server Type    : MySQL
 Source Server Version : 80029 (8.0.29)
 Source Host           : 192.168.150.101:3306
 Source Schema         : tj_data

 Target Server Type    : MySQL
 Target Server Version : 80029 (8.0.29)
 File Encoding         : 65001

 Date: 26/06/2025 19:49:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for course_profile
-- ----------------------------
DROP TABLE IF EXISTS `course_profile`;
CREATE TABLE `course_profile`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `course_id` bigint NULL DEFAULT NULL COMMENT '课程id',
  `sex_label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '访问用户的性别标签',
  `province_labels` json NULL COMMENT '访问用户的省份标签 只存储前5个',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_course_conversion_dpv
-- ----------------------------
DROP TABLE IF EXISTS `tab_course_conversion_dpv`;
CREATE TABLE `tab_course_conversion_dpv`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `do_browse_dpv` bigint NULL DEFAULT NULL COMMENT '课程浏览次数',
  `do_order_dpv` bigint NULL DEFAULT NULL COMMENT '课程下单次数',
  `conversion_rate` double NULL DEFAULT NULL COMMENT '课程转化率',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_course_detail_gender_duv
-- ----------------------------
DROP TABLE IF EXISTS `tab_course_detail_gender_duv`;
CREATE TABLE `tab_course_detail_gender_duv`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `man_dpv` bigint NULL DEFAULT NULL COMMENT '男：日课程详情访问数',
  `woman_dpv` bigint NULL DEFAULT NULL COMMENT '女：日课程详情访问数',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_course_detail_province_duv
-- ----------------------------
DROP TABLE IF EXISTS `tab_course_detail_province_duv`;
CREATE TABLE `tab_course_detail_province_duv`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `province_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省',
  `duv` bigint NULL DEFAULT NULL COMMENT '省日课程用户访问数',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_dau
-- ----------------------------
DROP TABLE IF EXISTS `tab_dau`;
CREATE TABLE `tab_dau`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `all_dau` bigint NULL DEFAULT NULL COMMENT '总用户活跃数',
  `new_dau` bigint NULL DEFAULT NULL COMMENT '老用户活跃数',
  `old_dau` bigint NULL DEFAULT NULL COMMENT '新用户活跃数',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_dau_province
-- ----------------------------
DROP TABLE IF EXISTS `tab_dau_province`;
CREATE TABLE `tab_dau_province`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `dau` bigint NULL DEFAULT NULL COMMENT '活跃用户数',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_province_report_time`(`province` ASC, `report_time` ASC) USING BTREE,
  INDEX `idx_report_time`(`report_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '活跃用户所属省份' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_dau_range
-- ----------------------------
DROP TABLE IF EXISTS `tab_dau_range`;
CREATE TABLE `tab_dau_range`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `dau_rang` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活跃数区间',
  `user_num` bigint NULL DEFAULT NULL COMMENT '用户数',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_dnu
-- ----------------------------
DROP TABLE IF EXISTS `tab_dnu`;
CREATE TABLE `tab_dnu`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `dnu` bigint NULL DEFAULT NULL COMMENT '日新增用户数',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_dpv
-- ----------------------------
DROP TABLE IF EXISTS `tab_dpv`;
CREATE TABLE `tab_dpv`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `dpv` bigint NULL DEFAULT NULL COMMENT '日访问页面量',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_dpv_time
-- ----------------------------
DROP TABLE IF EXISTS `tab_dpv_time`;
CREATE TABLE `tab_dpv_time`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `mid_night_dpv` bigint NULL DEFAULT NULL COMMENT '0~7点活跃访问量数（不包括右区间）',
  `noon_dpv` bigint NULL DEFAULT NULL COMMENT '7~12点活跃访问量数（不包括右区间）',
  `afternoon_dpv` bigint NULL DEFAULT NULL COMMENT '12~18点活跃访问量数（不包括右区间）',
  `evening_dpv` bigint NULL DEFAULT NULL COMMENT '18~24点活跃访问量数（不包括右区间）',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_report_time`(`report_time` ASC) USING BTREE COMMENT '确保每个统计时间唯一'
) ENGINE = InnoDB AUTO_INCREMENT = 1937496827599806467 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tab_duv
-- ----------------------------
DROP TABLE IF EXISTS `tab_duv`;
CREATE TABLE `tab_duv`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `duv` bigint NULL DEFAULT NULL COMMENT '日唯一访问量',
  `report_time` date NULL DEFAULT NULL COMMENT '统计时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile`  (
  `id` bigint NOT NULL COMMENT '主键 ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `sex` int NULL DEFAULT NULL COMMENT '性别：0-男性，1-女性',
  `province` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省',
  `course_labels` json NULL COMMENT '用户偏好  常访问课程id 前5',
  `free_label` int NULL DEFAULT NULL COMMENT '用户偏好  付费课程还是免费课程 0免费1付费',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ============================================================
-- 学习数据分析中心 — 新增表（学习漏斗、章节流失、教师转化、留存等）
-- ============================================================

-- ----------------------------
-- Table structure for analytics_course_ranking (课程排行榜快照)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_course_ranking`;
CREATE TABLE `analytics_course_ranking` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `course_name` varchar(255) NOT NULL COMMENT '课程名称',
  `teacher_id` bigint DEFAULT NULL COMMENT '教师ID',
  `teacher_name` varchar(128) DEFAULT NULL COMMENT '教师名称',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `exposure_pv` bigint NOT NULL DEFAULT 0 COMMENT '曝光量（列表页展示次数）',
  `click_pv` bigint NOT NULL DEFAULT 0 COMMENT '点击数（详情页进入次数）',
  `purchase_uv` bigint NOT NULL DEFAULT 0 COMMENT '购买人数',
  `enroll_uv` bigint NOT NULL DEFAULT 0 COMMENT '报课人数（已报名未开始学）',
  `start_uv` bigint NOT NULL DEFAULT 0 COMMENT '开课人数（至少学了一节）',
  `complete_uv` bigint NOT NULL DEFAULT 0 COMMENT '完课人数',
  `total_revenue` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '总收入',
  `avg_score` decimal(3,2) DEFAULT NULL COMMENT '平均评分',
  `rating_count` int NOT NULL DEFAULT 0 COMMENT '评价数',
  `rank_position` int DEFAULT NULL COMMENT '综合排名',
  `report_date` date NOT NULL COMMENT '统计日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_report_date_rank` (`report_date`, `rank_position`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程排行榜每日快照';

-- ----------------------------
-- Table structure for analytics_learning_funnel (学习转化漏斗)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_learning_funnel`;
CREATE TABLE `analytics_learning_funnel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `step` tinyint NOT NULL COMMENT '漏斗阶段：1-曝光 2-点击 3-购买 4-报课 5-开课 6-完课',
  `step_name` varchar(32) NOT NULL COMMENT '阶段名称',
  `user_count` bigint NOT NULL DEFAULT 0 COMMENT '到达该阶段的用户数',
  `step_conversion_rate` decimal(5,2) DEFAULT NULL COMMENT '本阶段转化率(%)',
  `total_conversion_rate` decimal(5,2) DEFAULT NULL COMMENT '整体转化率（相对曝光）(%)',
  `avg_stay_seconds` int DEFAULT NULL COMMENT '本阶段平均停留时长(秒)',
  `report_date` date NOT NULL COMMENT '统计日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_date` (`course_id`, `report_date`),
  KEY `idx_step` (`step`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习转化漏斗（天级汇总）';

-- ----------------------------
-- Table structure for analytics_chapter_retention (章节留存/流失)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_chapter_retention`;
CREATE TABLE `analytics_chapter_retention` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `chapter_id` bigint NOT NULL COMMENT '章ID',
  `chapter_name` varchar(255) NOT NULL COMMENT '章名称',
  `chapter_index` int NOT NULL COMMENT '章序号',
  `total_section_count` int NOT NULL DEFAULT 0 COMMENT '本章小节总数',
  `enter_uv` bigint NOT NULL DEFAULT 0 COMMENT '进入本章用户数',
  `complete_uv` bigint NOT NULL DEFAULT 0 COMMENT '完成本章用户数',
  `drop_off_uv` bigint NOT NULL DEFAULT 0 COMMENT '本章流失用户数（进入但未完成）',
  `retention_rate` decimal(5,2) DEFAULT NULL COMMENT '本章留存率(%)',
  `avg_completion_pct` decimal(5,2) DEFAULT NULL COMMENT '平均完成度(%)',
  `report_date` date NOT NULL COMMENT '统计日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_chapter` (`course_id`, `chapter_index`),
  KEY `idx_report_date` (`report_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='章节留存/流失分析';

-- ----------------------------
-- Table structure for analytics_teacher_conversion (教师转化指标)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_teacher_conversion`;
CREATE TABLE `analytics_teacher_conversion` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `teacher_id` bigint NOT NULL COMMENT '教师ID',
  `teacher_name` varchar(128) NOT NULL COMMENT '教师名称',
  `total_courses` int NOT NULL DEFAULT 0 COMMENT '在售课程数',
  `total_students` bigint NOT NULL DEFAULT 0 COMMENT '累计学员数',
  `new_students` bigint NOT NULL DEFAULT 0 COMMENT '当日新增学员',
  `total_revenue` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '累计收入',
  `daily_revenue` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '当日收入',
  `avg_course_score` decimal(3,2) DEFAULT NULL COMMENT '课程平均评分',
  `avg_completion_rate` decimal(5,2) DEFAULT NULL COMMENT '学员平均完课率(%)',
  `repurchase_rate` decimal(5,2) DEFAULT NULL COMMENT '学员复购率(%)',
  `report_date` date NOT NULL COMMENT '统计日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_teacher_date` (`teacher_id`, `report_date`),
  KEY `idx_report_date` (`report_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师转化指标';

-- ----------------------------
-- Table structure for analytics_learning_retention (N日学习留存)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_learning_retention`;
CREATE TABLE `analytics_learning_retention` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `base_date` date NOT NULL COMMENT '基准日期（首次学习日）',
  `day_n` tinyint NOT NULL COMMENT '第N日（1/3/7/14/30）',
  `retained_users` bigint NOT NULL DEFAULT 0 COMMENT '留存用户数',
  `total_users` bigint NOT NULL DEFAULT 0 COMMENT '基准日新增学习用户总数',
  `retention_rate` decimal(5,2) DEFAULT NULL COMMENT '留存率(%)',
  `report_date` date NOT NULL COMMENT '计算日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_base_date` (`base_date`),
  KEY `idx_day_n` (`day_n`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='N日学习留存分析';

-- ----------------------------
-- Table structure for analytics_user_learning_profile (用户学习画像)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_user_learning_profile`;
CREATE TABLE `analytics_user_learning_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_study_seconds` bigint NOT NULL DEFAULT 0 COMMENT '累计学习时长(秒)',
  `total_courses_enrolled` int NOT NULL DEFAULT 0 COMMENT '报课总数',
  `total_courses_completed` int NOT NULL DEFAULT 0 COMMENT '完课总数',
  `preferred_categories` json DEFAULT NULL COMMENT '偏好分类 [{categoryId,weight}]',
  `preferred_study_hours` json DEFAULT NULL COMMENT '偏好学习时段 {0:0.1, 1:0.05, ...23:0.3}',
  `avg_daily_study_minutes` int DEFAULT 0 COMMENT '日均学习时长(分钟)',
  `study_streak_days` int DEFAULT 0 COMMENT '连续学习天数',
  `last_study_date` date DEFAULT NULL COMMENT '最近学习日期',
  `churn_risk` decimal(3,2) DEFAULT NULL COMMENT '流失风险 0-1',
  `active_level` tinyint DEFAULT 2 COMMENT '活跃度：1-低 2-中 3-高',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户学习画像';

-- ----------------------------
-- Table structure for analytics_event_tracking_def (埋点事件定义)
-- ----------------------------
DROP TABLE IF EXISTS `analytics_event_tracking_def`;
CREATE TABLE `analytics_event_tracking_def` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `event_code` varchar(64) NOT NULL COMMENT '事件编码',
  `event_name` varchar(128) NOT NULL COMMENT '事件名称',
  `event_category` varchar(64) NOT NULL COMMENT '事件分类：exposure/click/purchase/learning/retention',
  `trigger_page` varchar(255) DEFAULT NULL COMMENT '触发页面路径',
  `trigger_element` varchar(128) DEFAULT NULL COMMENT '触发元素',
  `params_schema` json DEFAULT NULL COMMENT '参数定义 [{field,type,desc}]',
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_code` (`event_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='埋点事件定义表';

-- ----------------------------
-- 预置埋点事件
-- ----------------------------
INSERT INTO `analytics_event_tracking_def` (`event_code`, `event_name`, `event_category`, `trigger_page`, `trigger_element`, `params_schema`) VALUES
('course_list_view', '课程列表曝光', 'exposure', '/courses', 'course-card', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"position","type":"int","desc":"展示位置"}]'),
('course_detail_view', '课程详情页浏览', 'exposure', '/courses/{id}', 'page-view', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"from","type":"string","desc":"来源"}]'),
('course_detail_cta_click', '课程详情页CTA点击', 'click', '/courses/{id}', 'enroll-btn', '[{"field":"course_id","type":"long","desc":"课程ID"}]'),
('course_purchase_start', '购买流程发起', 'purchase', '/checkout', 'checkout-btn', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"price","type":"decimal","desc":"价格"}]'),
('course_purchase_success', '购买成功', 'purchase', '/checkout/success', 'success-page', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"order_id","type":"long","desc":"订单ID"},{"field":"amount","type":"decimal","desc":"实付金额"}]'),
('lesson_start', '小节开始学习', 'learning', '/learning/{lessonId}/{sectionId}', 'video-player', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"chapter_id","type":"long","desc":"章ID"},{"field":"section_id","type":"long","desc":"节ID"}]'),
('lesson_progress', '小节学习进度', 'learning', '/learning/{lessonId}/{sectionId}', 'video-player', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"section_id","type":"long","desc":"节ID"},{"field":"progress_pct","type":"int","desc":"进度百分比"},{"field":"duration_seconds","type":"int","desc":"已观看秒数"}]'),
('lesson_complete', '小节完成', 'learning', '/learning/{lessonId}/{sectionId}', 'video-player', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"section_id","type":"long","desc":"节ID"},{"field":"total_duration","type":"int","desc":"总用时秒数"}]'),
('chapter_complete', '章节完成', 'learning', '/learning/{lessonId}', 'chapter-complete-toast', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"chapter_id","type":"long","desc":"章ID"}]'),
('course_complete', '课程完成', 'learning', '/learning/{lessonId}', 'certificate-page', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"total_days","type":"int","desc":"总学习天数"}]'),
('exercise_submit', '练习题提交', 'learning', '/learning/{lessonId}/exercise', 'submit-btn', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"section_id","type":"long","desc":"节ID"},{"field":"score","type":"int","desc":"得分"},{"field":"total","type":"int","desc":"总分"}]'),
('search_course', '搜索课程', 'click', '/search', 'search-input', '[{"field":"keyword","type":"string","desc":"搜索关键词"},{"field":"result_count","type":"int","desc":"结果数"}]'),
('recommend_click', '推荐位点击', 'click', '/', 'recommend-card', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"position","type":"int","desc":"位置"},{"field":"algo","type":"string","desc":"推荐算法"}]'),
('course_refund', '课程退课', 'purchase', '/orders/{id}/refund', 'refund-btn', '[{"field":"course_id","type":"long","desc":"课程ID"},{"field":"order_id","type":"long","desc":"订单ID"},{"field":"reason","type":"string","desc":"退课原因"}]');

-- ============================================================
-- 个性化学习路径推荐 — 新增表
-- ============================================================

-- ----------------------------
-- Table structure for rec_user_feature (用户特征快照)
-- ----------------------------
DROP TABLE IF EXISTS `rec_user_feature`;
CREATE TABLE `rec_user_feature` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `feature_type` tinyint NOT NULL COMMENT '特征类型：1-静态 2-动态',
  `feature_data` json NOT NULL COMMENT '特征数据',
  `feature_version` varchar(32) NOT NULL DEFAULT 'v1' COMMENT '特征版本号',
  `compute_time` datetime NOT NULL COMMENT '计算时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_type_version` (`user_id`, `feature_type`, `feature_version`),
  KEY `idx_compute_time` (`compute_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推荐用户特征快照';

-- ----------------------------
-- Table structure for rec_strategy_result (推荐策略结果缓存)
-- ----------------------------
DROP TABLE IF EXISTS `rec_strategy_result`;
CREATE TABLE `rec_strategy_result` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `strategy` varchar(32) NOT NULL COMMENT '策略标识：rule/cf/content/hybrid',
  `target_type` varchar(16) NOT NULL COMMENT '推荐目标：course/chapter/exercise/knowledge',
  `recommend_ids` json NOT NULL COMMENT '推荐ID列表 [{id,score,reason}]',
  `rec_context` json DEFAULT NULL COMMENT '推荐上下文（当前进度等）',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_strategy` (`user_id`, `strategy`, `target_type`),
  KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推荐策略结果缓存';

-- ----------------------------
-- Table structure for rec_feedback (推荐反馈)
-- ----------------------------
DROP TABLE IF EXISTS `rec_feedback`;
CREATE TABLE `rec_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `recommend_id` bigint NOT NULL COMMENT '推荐内容ID（课程/章节/练习ID）',
  `target_type` varchar(16) NOT NULL COMMENT '目标类型',
  `strategy` varchar(32) NOT NULL COMMENT '推荐策略',
  `action` tinyint NOT NULL COMMENT '动作：1-曝光 2-点击 3-收藏 4-购买 5-学习 6-完成 7-忽略 8-负反馈',
  `position` int DEFAULT NULL COMMENT '展示位置',
  `reason` varchar(512) DEFAULT NULL COMMENT '推荐理由',
  `session_id` varchar(64) DEFAULT NULL COMMENT '会话ID，用于串联曝光→点击链路',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_time` (`user_id`, `create_time`),
  KEY `idx_recommend_id` (`recommend_id`),
  KEY `idx_strategy` (`strategy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推荐反馈日志';

-- ----------------------------
-- Table structure for rec_course_similarity (课程相似度矩阵)
-- ----------------------------
DROP TABLE IF EXISTS `rec_course_similarity`;
CREATE TABLE `rec_course_similarity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id_a` bigint NOT NULL COMMENT '课程A ID',
  `course_id_b` bigint NOT NULL COMMENT '课程B ID',
  `similarity` decimal(6,5) NOT NULL COMMENT '相似度 0-1',
  `similarity_type` tinyint NOT NULL COMMENT '相似度类型：1-内容相似 2-协同相似 3-知识图谱相似',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pair` (`course_id_a`, `course_id_b`, `similarity_type`),
  KEY `idx_course_a` (`course_id_a`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程相似度矩阵';

SET FOREIGN_KEY_CHECKS = 1;
