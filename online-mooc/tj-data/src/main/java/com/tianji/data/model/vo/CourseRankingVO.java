package com.tianji.data.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("课程排行项")
public class CourseRankingVO {
    @ApiModelProperty("排名")
    private Integer rank;
    private Long courseId;
    private String courseName;
    private String teacherName;
    @ApiModelProperty("曝光量")
    private Long exposurePv;
    @ApiModelProperty("购买人数")
    private Long purchaseUv;
    @ApiModelProperty("完课人数")
    private Long completeUv;
    @ApiModelProperty("转化率(曝光→购买) %")
    private BigDecimal conversionRate;
    @ApiModelProperty("总收入")
    private BigDecimal totalRevenue;
    @ApiModelProperty("平均评分")
    private BigDecimal avgScore;
}
