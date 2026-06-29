package com.tianji.chat.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;
import java.util.List;

/**
 * AI学习路径推荐记录
 */
@Data
@Accessors(chain = true)
@TableName(value = "ai_learning_path", autoResultMap = true)
public class AiLearningPath {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String sessionId;

    private String suggestion;

    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Long> recommendedCourses;

    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<String> weakPoints;

    private LocalDateTime createTime;
}
