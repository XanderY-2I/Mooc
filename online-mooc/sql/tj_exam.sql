/*
 Navicat Premium Dump SQL

 Source Server         : tianji
 Source Server Type    : MySQL
 Source Server Version : 80029 (8.0.29)
 Source Host           : 192.168.150.101:3306
 Source Schema         : tj_exam

 Target Server Type    : MySQL
 Target Server Version : 80029 (8.0.29)
 File Encoding         : 65001

 Date: 26/06/2025 19:49:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for exam_record
-- ----------------------------
DROP TABLE IF EXISTS `exam_record`;
CREATE TABLE `exam_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '考试id',
  `type` tinyint NULL DEFAULT NULL COMMENT '类型，1-考试，2-练习',
  `course_id` bigint NULL DEFAULT NULL COMMENT '课程id',
  `section_id` bigint NULL DEFAULT NULL COMMENT '小节id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `score` int NULL DEFAULT NULL COMMENT '实际得分',
  `correct_questions` int NULL DEFAULT NULL COMMENT '正确答题数',
  `duration` int NULL DEFAULT NULL COMMENT '考试用时',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师评语',
  `finished` bit(1) NULL DEFAULT b'0' COMMENT '是否完成',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '交卷时间',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `exam_record_detail`;
CREATE TABLE `exam_record_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `exam_id` bigint NOT NULL COMMENT '考试记录id',
  `question_id` bigint NULL DEFAULT NULL COMMENT '问题id',
  `correct` bit(1) NULL DEFAULT b'0' COMMENT '是否正确',
  `score` int NULL DEFAULT NULL COMMENT '本题得分',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '考生答案',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师评语',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试记录明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` bigint NOT NULL COMMENT '题目id',
  `name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题干',
  `type` tinyint NOT NULL COMMENT '题目类型，1：单选题，2：多选题，3：不定向选择题，4：判断题，5：主观题',
  `cate_id1` bigint NOT NULL COMMENT '1级课程分类id',
  `cate_id2` bigint NOT NULL COMMENT '2级课程分类id',
  `cate_id3` bigint NOT NULL COMMENT '3级课程分类id',
  `difficulty` tinyint NOT NULL COMMENT '难易度，1：简单，2：中等，3：困难',
  `answer_times` int NOT NULL DEFAULT 0 COMMENT '回答次数',
  `correct_times` int NOT NULL DEFAULT 0 COMMENT '回答正确次数',
  `score` int NOT NULL COMMENT '分值',
  `dep_id` bigint NULL DEFAULT NULL COMMENT '部门id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creater` bigint NOT NULL DEFAULT 1 COMMENT '创建人',
  `updater` bigint NOT NULL DEFAULT 1 COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '题目' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for question_biz
-- ----------------------------
DROP TABLE IF EXISTS `question_biz`;
CREATE TABLE `question_biz`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_id` bigint NULL DEFAULT NULL COMMENT '业务id，要关联问题的某业务id，例如小节id',
  `question_id` bigint NULL DEFAULT NULL COMMENT '问题id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `biz_id`(`biz_id` ASC, `question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 237 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '问题和业务关联表，例如把小节id和问题id关联，一个小节下可以有多个问题' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for question_detail
-- ----------------------------
DROP TABLE IF EXISTS `question_detail`;
CREATE TABLE `question_detail`  (
  `id` bigint NOT NULL COMMENT '题目id',
  `options` json NULL COMMENT '选择题选项，json数组格式',
  `answer` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '选择题正确答案1到10，如果有多个答案，中间使用逗号隔开，如果是判断题，1：代表正确，其他代表错误',
  `analysis` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '答案解析',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '题目' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for undo_log
-- ----------------------------
DROP TABLE IF EXISTS `undo_log`;
CREATE TABLE `undo_log`  (
  `branch_id` bigint NOT NULL COMMENT 'branch transaction id',
  `xid` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'global transaction id',
  `context` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'undo_log context,such as serialization',
  `rollback_info` longblob NOT NULL COMMENT 'rollback info',
  `log_status` int NOT NULL COMMENT '0:normal status,1:defense status',
  `log_created` datetime(6) NOT NULL COMMENT 'create datetime',
  `log_modified` datetime(6) NOT NULL COMMENT 'modify datetime',
  UNIQUE INDEX `ux_undo_log`(`xid` ASC, `branch_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'AT transaction mode undo table' ROW_FORMAT = COMPACT;

-- ============================================================
-- 在线实验 / 编程练习沙箱 — 新增表
-- ============================================================

-- ----------------------------
-- Table structure for sandbox_question (编程题定义)
-- ----------------------------
DROP TABLE IF EXISTS `sandbox_question`;
CREATE TABLE `sandbox_question` (
  `id` bigint NOT NULL COMMENT '题目ID（关联 question.id）',
  `language` varchar(32) NOT NULL COMMENT '编程语言: java / python / cpp / c / go / javascript',
  `question_type` tinyint NOT NULL COMMENT '题型: 1-单文件代码 2-填空补全 3-输出匹配 4-综合实验',
  `code_template` text COMMENT '代码模板（预填给学生）',
  `blank_markers` json DEFAULT NULL COMMENT '填空标记 [{id,line,desc}]',
  `expected_output` text COMMENT '标准输出（输出匹配题使用）',
  `time_limit_ms` int NOT NULL DEFAULT 3000 COMMENT '时间限制(ms)',
  `memory_limit_kb` int NOT NULL DEFAULT 262144 COMMENT '内存限制(KB)，默认256MB',
  `run_command` varchar(256) DEFAULT NULL COMMENT '自定义运行命令',
  `build_command` varchar(256) DEFAULT NULL COMMENT '编译命令（编译型语言）',
  `allow_network` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否允许网络访问',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='编程沙箱题目定义';

-- ----------------------------
-- Table structure for sandbox_test_case (测试用例)
-- ----------------------------
DROP TABLE IF EXISTS `sandbox_test_case`;
CREATE TABLE `sandbox_test_case` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `case_index` int NOT NULL COMMENT '用例序号',
  `input_data` text COMMENT '标准输入',
  `expected_output` text COMMENT '期望输出',
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否隐藏用例（学生不可见）',
  `is_sample` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否示例用例（展示给学生）',
  `score_weight` decimal(5,2) NOT NULL DEFAULT 1.00 COMMENT '分值权重',
  `compare_mode` tinyint NOT NULL DEFAULT 1 COMMENT '比对模式: 1-精确匹配 2-忽略空白 3-正则匹配 4-自定义校验脚本',
  `compare_script` text COMMENT '自定义校验脚本（compare_mode=4时使用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_question_hidden` (`question_id`, `is_hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='编程题测试用例';

-- ----------------------------
-- Table structure for sandbox_submission (提交记录)
-- ----------------------------
DROP TABLE IF EXISTS `sandbox_submission`;
CREATE TABLE `sandbox_submission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提交ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `course_id` bigint DEFAULT NULL COMMENT '关联课程ID',
  `section_id` bigint DEFAULT NULL COMMENT '关联小节ID',
  `language` varchar(32) NOT NULL COMMENT '编程语言',
  `source_code` mediumtext NOT NULL COMMENT '提交的源代码',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '评测状态: 0-排队中 1-编译中 2-运行中 3-评测完成 4-编译错误 5-运行超时 6-运行错误 7-系统错误',
  `total_score` int DEFAULT 0 COMMENT '总分',
  `passed_cases` int DEFAULT 0 COMMENT '通过用例数',
  `total_cases` int DEFAULT 0 COMMENT '总用例数',
  `compile_error_msg` text COMMENT '编译错误信息',
  `exec_duration_ms` int DEFAULT NULL COMMENT '执行耗时(ms)',
  `exec_memory_kb` int DEFAULT NULL COMMENT '内存消耗(KB)',
  `submit_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `finish_time` datetime DEFAULT NULL COMMENT '评测完成时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_question` (`user_id`, `question_id`),
  KEY `idx_status` (`status`),
  KEY `idx_submit_time` (`submit_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='编程沙箱提交记录';

-- ----------------------------
-- Table structure for sandbox_case_result (单用例运行结果)
-- ----------------------------
DROP TABLE IF EXISTS `sandbox_case_result`;
CREATE TABLE `sandbox_case_result` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `submission_id` bigint NOT NULL COMMENT '提交ID',
  `case_id` bigint NOT NULL COMMENT '测试用例ID',
  `case_index` int NOT NULL COMMENT '用例序号',
  `is_passed` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否通过',
  `actual_output` text COMMENT '实际输出',
  `error_output` text COMMENT '错误输出(stderr)',
  `exec_duration_ms` int DEFAULT NULL COMMENT '本用例耗时(ms)',
  `exec_memory_kb` int DEFAULT NULL COMMENT '本用例内存(KB)',
  `exit_code` int DEFAULT NULL COMMENT '进程退出码',
  `score` int DEFAULT 0 COMMENT '本用例得分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_submission_id` (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='单用例评测结果';

-- ----------------------------
-- Table structure for sandbox_execution_log (执行回放日志)
-- ----------------------------
DROP TABLE IF EXISTS `sandbox_execution_log`;
CREATE TABLE `sandbox_execution_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `submission_id` bigint NOT NULL COMMENT '提交ID',
  `log_type` tinyint NOT NULL COMMENT '日志类型: 1-执行步骤 2-stdout 3-stderr 4-系统信息',
  `log_content` mediumtext COMMENT '日志内容',
  `timestamp_ms` bigint NOT NULL COMMENT '相对时间戳(ms)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_submission_log` (`submission_id`, `timestamp_ms`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代码执行回放日志';

-- ============================================================
-- 考试与作业增强 — 新增表（知识点、组卷、错题本、防作弊、主观题批改、申诉）
-- ============================================================

-- ----------------------------
-- Table structure for knowledge_point (知识点)
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_point`;
CREATE TABLE `knowledge_point` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '知识点ID',
  `name` varchar(255) NOT NULL COMMENT '知识点名称',
  `parent_id` bigint DEFAULT 0 COMMENT '父知识点ID（树形结构）',
  `course_id` bigint DEFAULT NULL COMMENT '关联课程ID',
  `category_id` bigint DEFAULT NULL COMMENT '关联分类ID',
  `description` varchar(1024) DEFAULT NULL COMMENT '描述',
  `level` tinyint NOT NULL DEFAULT 1 COMMENT '层级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识点';

-- ----------------------------
-- Table structure for question_knowledge_ref (题目-知识点关联)
-- ----------------------------
DROP TABLE IF EXISTS `question_knowledge_ref`;
CREATE TABLE `question_knowledge_ref` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question_id` bigint NOT NULL,
  `knowledge_id` bigint NOT NULL,
  `weight` decimal(3,2) NOT NULL DEFAULT 1.00 COMMENT '知识点权重',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qk` (`question_id`, `knowledge_id`),
  KEY `idx_knowledge_id` (`knowledge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目-知识点关联';

-- ----------------------------
-- Table structure for question_tag (题目标签)
-- ----------------------------
DROP TABLE IF EXISTS `question_tag`;
CREATE TABLE `question_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question_id` bigint NOT NULL,
  `tag` varchar(64) NOT NULL COMMENT '标签: 高频考点/易错题/真题/模拟题/章节练习',
  PRIMARY KEY (`id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目标签';

-- ----------------------------
-- Table structure for exam_paper_template (试卷模板 — 用于自动组卷)
-- ----------------------------
DROP TABLE IF EXISTS `exam_paper_template`;
CREATE TABLE `exam_paper_template` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '模板名称',
  `course_id` bigint DEFAULT NULL COMMENT '课程ID',
  `total_score` int NOT NULL DEFAULT 100 COMMENT '总分',
  `duration_minutes` int NOT NULL DEFAULT 60 COMMENT '考试时长(分钟)',
  `rules` json NOT NULL COMMENT '组卷规则 [{type:1, count:10, difficulty:[1,2], score_per:2, knowledge_ids:[...], tags:[...]}]',
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='组卷模板';

-- ----------------------------
-- Table structure for exam_paper (试卷实例)
-- ----------------------------
DROP TABLE IF EXISTS `exam_paper`;
CREATE TABLE `exam_paper` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '试卷ID',
  `template_id` bigint DEFAULT NULL COMMENT '模板ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `name` varchar(255) NOT NULL COMMENT '试卷名称',
  `total_score` int NOT NULL DEFAULT 100,
  `duration_minutes` int NOT NULL DEFAULT 60,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-草稿 1-已发布 2-已关闭',
  `start_time` datetime DEFAULT NULL COMMENT '考试开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '考试结束时间',
  `shuffle_questions` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否随机排列题目',
  `shuffle_options` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否随机排列选项',
  `allow_retry` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否允许重考',
  `show_answer_after` tinyint NOT NULL DEFAULT 1 COMMENT '0-不展示 1-交卷后展示 2-成绩公布后展示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷';

-- ----------------------------
-- Table structure for exam_paper_question (试卷-题目快照)
-- ----------------------------
DROP TABLE IF EXISTS `exam_paper_question`;
CREATE TABLE `exam_paper_question` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `paper_id` bigint NOT NULL COMMENT '试卷ID',
  `question_id` bigint NOT NULL COMMENT '原题目ID',
  `question_snapshot` json NOT NULL COMMENT '题目快照（题干/选项/答案/解析，冻结组卷时的状态）',
  `score` int NOT NULL DEFAULT 0 COMMENT '本题分值',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `idx_paper_id` (`paper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷题目快照';

-- ----------------------------
-- Table structure for user_error_book (错题本)
-- ----------------------------
DROP TABLE IF EXISTS `user_error_book`;
CREATE TABLE `user_error_book` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `paper_id` bigint DEFAULT NULL COMMENT '试卷ID',
  `exam_record_id` bigint DEFAULT NULL COMMENT '考试记录ID',
  `user_answer` varchar(1024) DEFAULT NULL COMMENT '用户错误答案',
  `error_count` int NOT NULL DEFAULT 1 COMMENT '累计错误次数',
  `last_error_time` datetime NOT NULL COMMENT '最近错误时间',
  `mastered` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已掌握（连续答对3次后标记）',
  `note` varchar(512) DEFAULT NULL COMMENT '用户笔记',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_question` (`user_id`, `question_id`),
  KEY `idx_user_mastered` (`user_id`, `mastered`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错题本';

-- ----------------------------
-- Table structure for exam_anomaly_log (异常行为日志)
-- ----------------------------
DROP TABLE IF EXISTS `exam_anomaly_log`;
CREATE TABLE `exam_anomaly_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exam_record_id` bigint NOT NULL COMMENT '考试记录ID',
  `user_id` bigint NOT NULL,
  `anomaly_type` varchar(32) NOT NULL COMMENT '异常类型: tab_switch/window_blur/copy_paste/ip_change/multi_device/time_gap/suspicious_score',
  `anomaly_data` json DEFAULT NULL COMMENT '异常详情',
  `severity` tinyint NOT NULL DEFAULT 1 COMMENT '严重度: 1-提示 2-警告 3-严重',
  `detected_at` datetime NOT NULL COMMENT '检测时间',
  PRIMARY KEY (`id`),
  KEY `idx_exam_record` (`exam_record_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试异常行为日志';

-- ----------------------------
-- Table structure for essay_grading (主观题批改)
-- ----------------------------
DROP TABLE IF EXISTS `essay_grading`;
CREATE TABLE `essay_grading` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exam_record_detail_id` bigint NOT NULL COMMENT '考试记录明细ID',
  `student_answer` text NOT NULL COMMENT '学生答案',
  `reference_answer` text COMMENT '参考答案',
  `ai_score` int DEFAULT NULL COMMENT 'AI评分(0-100)',
  `ai_suggestion` text COMMENT 'AI批改建议',
  `teacher_score` int DEFAULT NULL COMMENT '教师评分',
  `teacher_comment` text COMMENT '教师评语',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-待批改 1-AI预批 2-教师已批 3-已发布',
  `grader_id` bigint DEFAULT NULL COMMENT '批改人ID',
  `graded_at` datetime DEFAULT NULL COMMENT '批改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_record_detail` (`exam_record_detail_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='主观题批改';

-- ----------------------------
-- Table structure for exam_appeal (成绩申诉)
-- ----------------------------
DROP TABLE IF EXISTS `exam_appeal`;
CREATE TABLE `exam_appeal` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exam_record_id` bigint NOT NULL,
  `question_id` bigint DEFAULT NULL COMMENT '申诉的题目ID（null=整卷申诉）',
  `user_id` bigint NOT NULL,
  `reason` varchar(1024) NOT NULL COMMENT '申诉理由',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-待处理 1-已受理 2-已驳回 3-已修正',
  `handler_id` bigint DEFAULT NULL COMMENT '处理人ID',
  `handle_comment` varchar(1024) DEFAULT NULL COMMENT '处理意见',
  `original_score` int DEFAULT NULL COMMENT '原得分',
  `revised_score` int DEFAULT NULL COMMENT '修正后得分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `handle_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_exam_record` (`exam_record_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩申诉';

SET FOREIGN_KEY_CHECKS = 1;
