package com.tianji.data.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("教师转化指标")
public class TeacherConversionVO {
    private Long teacherId;
    private String teacherName;
    @ApiModelProperty("在售课程数")
    private Integer totalCourses;
    @ApiModelProperty("累计学员")
    private Long totalStudents;
    @ApiModelProperty("当日新增学员")
    private Long newStudents;
    @ApiModelProperty("累计收入")
    private BigDecimal totalRevenue;
    @ApiModelProperty("当日收入")
    private BigDecimal dailyRevenue;
    @ApiModelProperty("课程平均评分")
    private BigDecimal avgCourseScore;
    @ApiModelProperty("学员平均完课率(%)")
    private BigDecimal avgCompletionRate;
    @ApiModelProperty("学员复购率(%)")
    private BigDecimal repurchaseRate;
}
