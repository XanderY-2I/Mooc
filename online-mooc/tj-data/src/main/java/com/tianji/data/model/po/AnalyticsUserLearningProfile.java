package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@TableName(value = "analytics_user_learning_profile", autoResultMap = true)
public class AnalyticsUserLearningProfile {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long totalStudySeconds;
    private Integer totalCoursesEnrolled;
    private Integer totalCoursesCompleted;

    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Map<String, Object>> preferredCategories;

    @TableField(typeHandler = JacksonTypeHandler.class)
    private Map<Integer, Double> preferredStudyHours;

    private Integer avgDailyStudyMinutes;
    private Integer studyStreakDays;
    private LocalDate lastStudyDate;
    private java.math.BigDecimal churnRisk;
    private Integer activeLevel;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
