package com.tianji.exam.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
@ApiModel("代码提交请求")
public class SandboxSubmitDTO {

    @NotNull @ApiModelProperty("题目ID")
    private Long questionId;

    @ApiModelProperty("课程ID（可选，关联学习上下文）")
    private Long courseId;

    @ApiModelProperty("小节ID（可选）")
    private Long sectionId;

    @NotBlank @ApiModelProperty("编程语言")
    private String language;

    @NotBlank @ApiModelProperty("源代码")
    private String sourceCode;
}
