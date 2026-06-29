package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("study_note")
public class StudyNote {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long courseId;
    private Long sectionId;
    private String title;
    private String content;
    private Integer visibility;
    private Long groupId;
    private Integer likeCount;
    private Integer bookmarkCount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
