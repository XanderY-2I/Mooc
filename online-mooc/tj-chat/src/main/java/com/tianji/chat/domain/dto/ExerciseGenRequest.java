package com.tianji.chat.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 练习题生成请求
 */
@Data
@ApiModel("练习题生成请求")
public class ExerciseGenRequest {

    @NotNull
    @ApiModelProperty(value = "课程ID", required = true)
    private Long courseId;

    @ApiModelProperty(value = "小节ID（可选）")
    private Long sectionId;

    @ApiModelProperty(value = "题目数量", example = "5")
    @Min(1)
    private Integer count = 5;

    @ApiModelProperty(value = "难度：1-简单 2-中等 3-困难", example = "2")
    private Integer difficulty = 2;

    @ApiModelProperty(value = "题型：1-单选 2-多选 3-判断 4-填空 5-简答（逗号分隔多个）", example = "1,3")
    private String types;

    @ApiModelProperty(value = "指定知识点范围（可选）")
    private String knowledgePoints;
}
