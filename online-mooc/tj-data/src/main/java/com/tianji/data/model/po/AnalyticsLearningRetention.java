package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("analytics_learning_retention")
public class AnalyticsLearningRetention {
    @TableId(type = IdType.AUTO)
    private Long id;
    private LocalDate baseDate;
    private Integer dayN;
    private Long retainedUsers;
    private Long totalUsers;
    private java.math.BigDecimal retentionRate;
    private LocalDate reportDate;
    private LocalDateTime createTime;
}
