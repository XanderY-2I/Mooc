package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@TableName(value = "exam_anomaly_log", autoResultMap = true)
public class ExamAnomalyLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long examRecordId;
    private Long userId;
    private String anomalyType;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private Map<String, Object> anomalyData;
    private Integer severity;
    private LocalDateTime detectedAt;
}
