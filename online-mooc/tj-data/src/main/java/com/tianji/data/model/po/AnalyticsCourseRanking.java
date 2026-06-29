package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("analytics_course_ranking")
public class AnalyticsCourseRanking {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private String courseName;
    private Long teacherId;
    private String teacherName;
    private Long categoryId;
    private Long exposurePv;
    private Long clickPv;
    private Long purchaseUv;
    private Long enrollUv;
    private Long startUv;
    private Long completeUv;
    private BigDecimal totalRevenue;
    private java.math.BigDecimal avgScore;
    private Integer ratingCount;
    private Integer rankPosition;
    private LocalDate reportDate;
    private LocalDateTime createTime;
}
