package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("study_challenge")
public class StudyChallenge {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String description;
    private Integer challengeType;
    private Integer targetValue;
    private Long courseId;
    private Long groupId;
    private Long creatorId;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer participantCount;
    private Integer status;
    private LocalDateTime createTime;
}
