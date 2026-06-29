package com.tianji.chat.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 会话列表项
 */
@Data
@ApiModel("会话列表")
public class SessionVO {

    @ApiModelProperty("会话ID")
    private String sessionId;

    @ApiModelProperty("会话标题（首条提问截取）")
    private String title;

    @ApiModelProperty("对话类型")
    private Integer conversationType;

    @ApiModelProperty("消息数量")
    private Integer messageCount;

    @ApiModelProperty("创建时间")
    private LocalDateTime createTime;
}
