package com.tianji.live.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("live_room")
public class LiveRoom {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private Long sectionId;
    private Long teacherId;
    private String title;
    private Integer status;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private LocalDateTime actualStartTime;
    private LocalDateTime actualEndTime;
    private Integer onlineCount;
    private Integer totalViewCount;
    private String replayUrl;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
