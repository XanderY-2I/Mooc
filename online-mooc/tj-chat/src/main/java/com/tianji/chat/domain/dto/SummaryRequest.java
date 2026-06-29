package com.tianji.chat.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 知识点总结请求
 */
@Data
@ApiModel("知识点总结请求")
public class SummaryRequest {

    @NotNull
    @ApiModelProperty(value = "课程ID", required = true)
    private Long courseId;

    @ApiModelProperty(value = "小节ID（传入则总结单节，不传则总结整章）")
    private Long sectionId;

    @ApiModelProperty(value = "总结风格：brief-简要/ detailed-详细/ mindmap-思维导图", example = "brief")
    private String style = "brief";
}
