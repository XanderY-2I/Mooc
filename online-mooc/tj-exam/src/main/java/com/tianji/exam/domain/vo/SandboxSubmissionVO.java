package com.tianji.exam.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@ApiModel("提交结果视图")
public class SandboxSubmissionVO {
    @ApiModelProperty("提交ID")
    private Long id;
    @ApiModelProperty("评测状态: 0-排队 1-编译中 2-运行中 3-完成 4-编译错误 5-超时 6-运行错误 7-系统错误")
    private Integer status;
    @ApiModelProperty("状态文本")
    private String statusText;
    @ApiModelProperty("总分")
    private Integer totalScore;
    @ApiModelProperty("通过/总用例数")
    private String caseSummary;
    @ApiModelProperty("编译错误信息")
    private String compileErrorMsg;
    @ApiModelProperty("总执行时长(ms)")
    private Integer execDurationMs;
    @ApiModelProperty("内存消耗(KB)")
    private Integer execMemoryKb;
    @ApiModelProperty("提交时间")
    private LocalDateTime submitTime;
    @ApiModelProperty("完成时间")
    private LocalDateTime finishTime;
    @ApiModelProperty("单用例结果详情")
    private List<CaseResultItem> caseResults;

    @Data
    public static class CaseResultItem {
        private Integer caseIndex;
        private Boolean isPassed;
        private Integer score;
        private String actualOutput;
        @ApiModelProperty("是否隐藏用例（学生端不展示详情）")
        private Boolean isHidden;
    }
}
