package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("essay_grading")
public class EssayGrading {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long examRecordDetailId;
    private String studentAnswer;
    private String referenceAnswer;
    private Integer aiScore;
    private String aiSuggestion;
    private Integer teacherScore;
    private String teacherComment;
    private Integer status;
    private Long graderId;
    private LocalDateTime gradedAt;
}
