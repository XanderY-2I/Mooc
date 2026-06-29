package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("exam_paper")
public class ExamPaper {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long templateId;
    private Long courseId;
    private String name;
    private Integer totalScore;
    private Integer durationMinutes;
    private Integer status;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Boolean shuffleQuestions;
    private Boolean shuffleOptions;
    private Boolean allowRetry;
    private Integer showAnswerAfter;
    private LocalDateTime createTime;
}
