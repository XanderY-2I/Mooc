package com.tianji.live.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("live_interaction")
public class LiveInteraction {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long roomId;
    private Long userId;
    private String userName;
    private String interactionType;
    private String content;
    private String payload;
    private Long timestampMs;
    private Boolean isCensored;
    private LocalDateTime createTime;
}
