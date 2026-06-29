package com.tianji.chat.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

/**
 * AI知识库文本分段（元数据索引）
 */
@Data
@Accessors(chain = true)
@TableName("ai_knowledge_chunk")
public class AiKnowledgeChunk {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 来源文档标识: course:1001 / video:subtitle:2001 */
    private String docId;

    private Long courseId;

    private Long sectionId;

    /** 内容类型：1-课程介绍 2-讲义 3-视频字幕 4-PDF 5-题目 6-评论精华 */
    private Integer contentType;

    private Integer chunkIndex;

    private String title;

    private String content;

    /** Qdrant 中对应的 point ID */
    private String qdrantPointId;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
