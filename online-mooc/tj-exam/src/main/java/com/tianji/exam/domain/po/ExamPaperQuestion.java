package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.util.Map;

@Data
@TableName(value = "exam_paper_question", autoResultMap = true)
public class ExamPaperQuestion {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long paperId;
    private Long questionId;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private Map<String, Object> questionSnapshot;
    private Integer score;
    private Integer sortOrder;
}
