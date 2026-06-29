package com.tianji.chat.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * AI练习题视图
 */
@Data
@ApiModel("AI练习题")
public class ExerciseVO {

    @ApiModelProperty("练习ID")
    private Long id;

    @ApiModelProperty("题目类型：1-单选 2-多选 3-判断 4-填空 5-简答")
    private Integer exerciseType;

    @ApiModelProperty("难度：1-简单 2-中等 3-困难")
    private Integer difficulty;

    @ApiModelProperty("题目内容")
    private String question;

    @ApiModelProperty("选项（选择题）")
    private List<String> options;

    @ApiModelProperty("正确答案")
    private String answer;

    @ApiModelProperty("答案解析")
    private String analysis;

    @ApiModelProperty("考察知识点")
    private String knowledgePoint;
}
