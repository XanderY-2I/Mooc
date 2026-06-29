package com.tianji.live.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("live_bookmark")
public class LiveBookmark {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long roomId;
    private Long userId;
    private Integer scope;
    private String label;
    private String note;
    private Long timestampMs;
    private LocalDateTime createTime;
}
