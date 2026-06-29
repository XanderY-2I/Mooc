package com.tianji.chat.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

/**
 * AI助手对话历史
 */
@Data
@Accessors(chain = true)
@TableName("ai_conversation")
public class AiConversation {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    /** 会话ID（UUID格式） */
    private String sessionId;

    /** 对话类型：1-课程问答 2-知识点总结 3-错题讲解 4-练习题生成 5-学习路径 */
    private Integer conversationType;

    private Long courseId;

    private Long sectionId;

    /** 用户提问原文 */
    private String question;

    /** AI回答内容（Markdown） */
    private String answer;

    /** 引用来源 JSON [{docId,title,excerpt}] */
    private String sources;

    private Integer promptTokens;

    private Integer completionTokens;

    /** 用户评分 1-5 */
    private Integer rating;

    private LocalDateTime createTime;
}
