package com.tianji.media.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("video_network_log")
public class VideoNetworkLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long mediaId;
    private String networkType;
    private Integer effectiveBandwidthKbps;
    private Integer bufferingCount;
    private Integer bufferingDurationMs;
    private Integer avgBitrateKbps;
    private String switchFromQuality;
    private String switchToQuality;
    private LocalDateTime createTime;
}
