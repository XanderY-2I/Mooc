package com.tianji.exam.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;

@Data
@ApiModel("编程题创建/编辑请求")
public class SandboxQuestionDTO {

    private Long id;

    @NotNull @ApiModelProperty("题型: 1-单文件代码 2-填空补全 3-输出匹配 4-综合实验")
    private Integer questionType;

    @NotBlank @ApiModelProperty("编程语言")
    private String language;

    @ApiModelProperty("代码模板")
    private String codeTemplate;

    @ApiModelProperty("填空标记")
    private List<Map<String, Object>> blankMarkers;

    @ApiModelProperty("标准输出（输出匹配题）")
    private String expectedOutput;

    @NotNull @ApiModelProperty("时间限制(ms)")
    private Integer timeLimitMs = 3000;

    @NotNull @ApiModelProperty("内存限制(KB)")
    private Integer memoryLimitKb = 262144;

    @ApiModelProperty("运行命令")
    private String runCommand;

    @ApiModelProperty("编译命令")
    private String buildCommand;

    @ApiModelProperty("是否允许网络")
    private Boolean allowNetwork = false;

    // ---- 关联 question 表字段 ----
    @NotBlank @ApiModelProperty("题干")
    private String name;

    @NotNull @ApiModelProperty("题目类型: 6-编程题")
    private Integer type = 6;

    @NotNull @ApiModelProperty("难度: 1-简单 2-中等 3-困难")
    private Integer difficulty = 2;

    @NotNull @ApiModelProperty("分值")
    private Integer score;

    @ApiModelProperty("一级分类ID")
    private Long cateId1;

    @ApiModelProperty("二级分类ID")
    private Long cateId2;

    @ApiModelProperty("三级分类ID")
    private Long cateId3;

    @ApiModelProperty("关联业务ID（如小节ID）")
    private Long bizId;
}
