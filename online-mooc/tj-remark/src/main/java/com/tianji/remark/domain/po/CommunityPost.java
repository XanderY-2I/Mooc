package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName(value = "community_post", autoResultMap = true)
public class CommunityPost {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String title;
    private String content;
    private Integer postType;
    private Long courseId;
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Long> knowledgeIds;
    private Integer viewCount;
    private Integer likeCount;
    private Integer commentCount;
    private Boolean isEssence;
    private Boolean isPinned;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
