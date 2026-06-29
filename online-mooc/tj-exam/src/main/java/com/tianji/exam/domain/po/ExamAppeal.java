package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("exam_appeal")
public class ExamAppeal {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long examRecordId;
    private Long questionId;
    private Long userId;
    private String reason;
    private Integer status;
    private Long handlerId;
    private String handleComment;
    private Integer originalScore;
    private Integer revisedScore;
    private LocalDateTime createTime;
    private LocalDateTime handleTime;
}
