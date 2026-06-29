package com.tianji.media.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
@ApiModel("视频播放完整状态（用于断点续播恢复）")
public class VideoStateVO {
    @ApiModelProperty("当前播放位置(秒)")
    private Integer currentPosition;

    @ApiModelProperty("视频总时长(秒)")
    private Integer totalDuration;

    @ApiModelProperty("播放倍速")
    private BigDecimal playbackRate;

    @ApiModelProperty("当前清晰度")
    private String qualityLevel;

    @ApiModelProperty("音量")
    private Integer volume;

    @ApiModelProperty("字幕开关")
    private Boolean subtitleEnabled;

    @ApiModelProperty("字幕语言")
    private String subtitleLang;

    @ApiModelProperty("完成百分比")
    private BigDecimal completionPct;

    @ApiModelProperty("可用清晰度列表")
    private List<Map<String, Object>> qualities;

    @ApiModelProperty("建议预加载的下一节ID")
    private Long preloadSectionId;
}
