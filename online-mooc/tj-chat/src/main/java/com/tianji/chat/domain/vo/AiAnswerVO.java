package com.tianji.chat.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * AI 统一回答响应
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ApiModel("AI回答")
public class AiAnswerVO {

    @ApiModelProperty("会话ID")
    private String sessionId;

    @ApiModelProperty("回答内容（Markdown格式）")
    private String answer;

    @ApiModelProperty("引用来源列表")
    private List<SourceRef> sources;

    @ApiModelProperty("提示词消耗token数")
    private Integer promptTokens;

    @ApiModelProperty("回答消耗token数")
    private Integer completionTokens;

    @ApiModelProperty("创建时间")
    private LocalDateTime createTime;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SourceRef {
        @ApiModelProperty("文档标识")
        private String docId;
        @ApiModelProperty("文档标题")
        private String title;
        @ApiModelProperty("引用片段摘录")
        private String excerpt;
    }
}
