package com.tianji.media.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("video_preload_hint")
public class VideoPreloadHint {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private Long fromSectionId;
    private Long toSectionId;
    private Integer priority;
    private String reason;
    private LocalDateTime createTime;
}
