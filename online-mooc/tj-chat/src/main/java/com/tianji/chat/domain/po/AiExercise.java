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
 * AI生成的练习题
 */
@Data
@Accessors(chain = true)
@TableName(value = "ai_exercise", autoResultMap = true)
public class AiExercise {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long courseId;

    private Long sectionId;

    private String sessionId;

    /** 题型：1-单选 2-多选 3-判断 4-填空 5-简答 */
    private Integer exerciseType;

    /** 难度：1-简单 2-中等 3-困难 */
    private Integer difficulty;

    private String question;

    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<String> options;

    private String answer;

    private String analysis;

    private String knowledgePoint;

    private LocalDateTime createTime;
}
