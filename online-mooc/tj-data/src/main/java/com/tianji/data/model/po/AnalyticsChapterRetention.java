package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("analytics_chapter_retention")
public class AnalyticsChapterRetention {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private Long chapterId;
    private String chapterName;
    private Integer chapterIndex;
    private Integer totalSectionCount;
    private Long enterUv;
    private Long completeUv;
    private Long dropOffUv;
    private java.math.BigDecimal retentionRate;
    private java.math.BigDecimal avgCompletionPct;
    private LocalDate reportDate;
    private LocalDateTime createTime;
}
