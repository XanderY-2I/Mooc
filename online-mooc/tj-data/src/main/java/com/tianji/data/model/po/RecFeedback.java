package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("rec_feedback")
public class RecFeedback {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long recommendId;
    private String targetType;
    private String strategy;
    private Integer action;
    private Integer position;
    private String reason;
    private String sessionId;
    private LocalDateTime createTime;
}
