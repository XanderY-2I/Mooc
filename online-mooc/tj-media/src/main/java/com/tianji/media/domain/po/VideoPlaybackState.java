package com.tianji.media.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("video_playback_state")
public class VideoPlaybackState {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long mediaId;
    private Long courseId;
    private Long sectionId;
    private Integer currentPosition;
    private Integer totalDuration;
    private BigDecimal playbackRate;
    private String qualityLevel;
    private Integer volume;
    private Boolean subtitleEnabled;
    private String subtitleLang;
    private LocalDateTime lastHeartbeat;
    private Boolean completed;
    private BigDecimal completionPct;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
