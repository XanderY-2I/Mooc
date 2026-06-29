package com.tianji.media.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
@ApiModel("视频播放状态更新请求")
public class VideoStateUpdateDTO {

    @NotNull @ApiModelProperty("媒资ID")
    private Long mediaId;

    @ApiModelProperty("课程ID")
    private Long courseId;

    @ApiModelProperty("小节ID")
    private Long sectionId;

    @NotNull @ApiModelProperty("当前播放位置(秒)")
    private Integer currentPosition;

    @ApiModelProperty("视频总时长(秒)")
    private Integer totalDuration;

    @ApiModelProperty("播放倍速")
    private BigDecimal playbackRate;

    @ApiModelProperty("清晰度")
    private String qualityLevel;

    @ApiModelProperty("音量(0-100)")
    private Integer volume;

    @ApiModelProperty("是否开启字幕")
    private Boolean subtitleEnabled;

    @ApiModelProperty("字幕语言")
    private String subtitleLang;
}
