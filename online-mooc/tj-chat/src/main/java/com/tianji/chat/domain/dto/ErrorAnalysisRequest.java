package com.tianji.chat.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 错题讲解请求
 */
@Data
@ApiModel("错题讲解请求")
public class ErrorAnalysisRequest {

    @NotNull
    @ApiModelProperty(value = "考试记录ID", required = true)
    private Long examRecordId;

    @ApiModelProperty(value = "指定题目ID（可选，不传则分析全部错题）")
    private Long questionId;
}
