package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("analytics_teacher_conversion")
public class AnalyticsTeacherConversion {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long teacherId;
    private String teacherName;
    private Integer totalCourses;
    private Long totalStudents;
    private Long newStudents;
    private BigDecimal totalRevenue;
    private BigDecimal dailyRevenue;
    private java.math.BigDecimal avgCourseScore;
    private java.math.BigDecimal avgCompletionRate;
    private java.math.BigDecimal repurchaseRate;
    private LocalDate reportDate;
    private LocalDateTime createTime;
}
