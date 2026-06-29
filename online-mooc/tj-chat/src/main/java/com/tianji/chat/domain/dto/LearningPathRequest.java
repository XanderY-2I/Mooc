package com.tianji.chat.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 学习路径建议请求
 */
@Data
@ApiModel("学习路径建议请求")
public class LearningPathRequest {

    @ApiModelProperty(value = "目标课程ID（可选，分析该课程的先修路径）")
    private Long courseId;

    @ApiModelProperty(value = "学习目标描述", example = "希望三个月内掌握Java后端开发")
    private String goal;

    @ApiModelProperty(value = "是否包含用户历史学习记录分析", example = "true")
    private Boolean includeHistory = true;
}
