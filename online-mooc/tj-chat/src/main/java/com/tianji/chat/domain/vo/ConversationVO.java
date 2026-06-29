package com.tianji.chat.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 对话历史视图
 */
@Data
@ApiModel("对话历史")
public class ConversationVO {

    @ApiModelProperty("对话ID")
    private Long id;

    @ApiModelProperty("会话ID")
    private String sessionId;

    @ApiModelProperty("对话类型：1-问答 2-总结 3-错题 4-练习 5-学习路径")
    private Integer conversationType;

    @ApiModelProperty("用户提问")
    private String question;

    @ApiModelProperty("AI回答（摘要，最多200字）")
    private String answerPreview;

    @ApiModelProperty("用户评分")
    private Integer rating;

    @ApiModelProperty("创建时间")
    private LocalDateTime createTime;
}
