package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("study_checkin")
public class StudyCheckin {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long courseId;
    private Long groupId;
    private LocalDate checkinDate;
    private Integer studyMinutes;
    private Integer completedSections;
    private Integer mood;
    private String note;
    private LocalDateTime createTime;
}
