package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_error_book")
public class UserErrorBook {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long questionId;
    private Long paperId;
    private Long examRecordId;
    private String userAnswer;
    private Integer errorCount;
    private LocalDateTime lastErrorTime;
    private Boolean mastered;
    private String note;
    private LocalDateTime createTime;
}
