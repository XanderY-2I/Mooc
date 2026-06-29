package com.tianji.chat.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * AI提问请求
 */
@Data
@ApiModel("AI提问请求")
public class AiAskRequest {

    @ApiModelProperty(value = "会话ID（新会话不传）")
    private String sessionId;

    @NotBlank
    @ApiModelProperty(value = "提问内容")
    private String question;

    @ApiModelProperty(value = "关联课程ID（可选，限定检索范围）")
    private Long courseId;

    @ApiModelProperty(value = "关联小节ID（可选）")
    private Long sectionId;

    @ApiModelProperty(value = "对话类型：1-课程问答 2-知识点总结 3-错题讲解 4-练习题生成 5-学习路径", example = "1")
    private Integer conversationType = 1;
}
