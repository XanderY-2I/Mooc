package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("analytics_learning_funnel")
public class AnalyticsLearningFunnel {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private Integer step;
    private String stepName;
    private Long userCount;
    private java.math.BigDecimal stepConversionRate;
    private java.math.BigDecimal totalConversionRate;
    private Integer avgStaySeconds;
    private LocalDate reportDate;
    private LocalDateTime createTime;
}
