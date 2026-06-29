package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@TableName(value = "rec_user_feature", autoResultMap = true)
public class RecUserFeature {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Integer featureType;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private Map<String, Object> featureData;
    private String featureVersion;
    private LocalDateTime computeTime;
    private LocalDateTime createTime;
}
