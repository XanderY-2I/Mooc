package com.tianji.data.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@ApiModel("学习转化漏斗")
public class FunnelVO {
    @ApiModelProperty("课程ID")
    private Long courseId;
    @ApiModelProperty("课程名称")
    private String courseName;
    @ApiModelProperty("漏斗各阶段数据")
    private List<FunnelStep> steps;

    @Data
    public static class FunnelStep {
        @ApiModelProperty("阶段编号")
        private Integer step;
        @ApiModelProperty("阶段名称")
        private String name;
        @ApiModelProperty("用户数")
        private Long count;
        @ApiModelProperty("本阶段转化率(%)")
        private BigDecimal stepRate;
        @ApiModelProperty("整体转化率(%)")
        private BigDecimal totalRate;
    }
}
