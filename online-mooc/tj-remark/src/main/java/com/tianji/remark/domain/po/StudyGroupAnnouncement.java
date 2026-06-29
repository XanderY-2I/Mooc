package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("study_group_announcement")
public class StudyGroupAnnouncement {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long groupId;
    private Long authorId;
    private String title;
    private String content;
    private Boolean isPinned;
    private LocalDateTime createTime;
}
