package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("study_group")
public class StudyGroup {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String description;
    private Long courseId;
    private Long creatorId;
    private String avatarUrl;
    private Integer maxMembers;
    private Integer memberCount;
    private Integer status;
    private LocalDateTime createTime;
}
