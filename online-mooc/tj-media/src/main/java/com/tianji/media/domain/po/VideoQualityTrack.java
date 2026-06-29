package com.tianji.media.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("video_quality_track")
public class VideoQualityTrack {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long mediaId;
    private String qualityLevel;
    private Integer bitrateKbps;
    private String fileUrl;
    private Long fileSize;
    private Integer width;
    private Integer height;
    private String codec;
    private Boolean isDefault;
    private Integer transcodeStatus;
    private LocalDateTime createTime;
}
