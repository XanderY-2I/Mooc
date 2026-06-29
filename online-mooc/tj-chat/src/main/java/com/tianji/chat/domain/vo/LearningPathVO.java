package com.tianji.chat.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 学习路径建议视图
 */
@Data
@ApiModel("学习路径建议")
public class LearningPathVO {

    @ApiModelProperty("记录ID")
    private Long id;

    @ApiModelProperty("学习建议全文（Markdown）")
    private String suggestion;

    @ApiModelProperty("推荐课程ID列表")
    private List<Long> recommendedCourses;

    @ApiModelProperty("薄弱知识点")
    private List<String> weakPoints;

    @ApiModelProperty("生成时间")
    private LocalDateTime createTime;
}
