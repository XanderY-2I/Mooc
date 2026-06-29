package com.tianji.live.domain.po;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@TableName(value = "live_poll", autoResultMap = true)
public class LivePoll {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long roomId;
    private Long teacherId;
    private String title;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Map<String, Object>> options;
    private Boolean isMultiple;
    private Integer status;
    private Integer totalVotes;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private LocalDateTime createTime;
}
