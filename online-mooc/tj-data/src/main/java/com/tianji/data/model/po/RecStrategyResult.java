package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@TableName(value = "rec_strategy_result", autoResultMap = true)
public class RecStrategyResult {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String strategy;
    private String targetType;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Map<String, Object>> recommendIds;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private Map<String, Object> recContext;
    private LocalDateTime expireTime;
    private LocalDateTime createTime;
}
