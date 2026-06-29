package com.tianji.live.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("live_question")
public class LiveQuestion {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long roomId;
    private Long userId;
    private String userName;
    private String content;
    private String replyContent;
    private Integer status;
    private LocalDateTime pinnedAt;
    private Long timestampMs;
    private LocalDateTime createTime;
}
