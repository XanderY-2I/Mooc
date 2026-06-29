package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@TableName(value = "exam_paper_template", autoResultMap = true)
public class ExamPaperTemplate {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private Long courseId;
    private Integer totalScore;
    private Integer durationMinutes;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Map<String, Object>> rules;
    private Boolean isEnabled;
    private LocalDateTime createTime;
}
