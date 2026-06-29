package com.tianji.data.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@ApiModel("N日留存分析")
public class RetentionVO {
    @ApiModelProperty("基准日期")
    private String baseDate;
    @ApiModelProperty("基准日新增学习用户数")
    private Long totalUsers;
    @ApiModelProperty("各N日留存")
    private List<RetentionDay> days;

    @Data
    public static class RetentionDay {
        @ApiModelProperty("第N日")
        private Integer dayN;
        @ApiModelProperty("留存用户数")
        private Long retainedUsers;
        @ApiModelProperty("留存率(%)")
        private BigDecimal rate;
    }
}
