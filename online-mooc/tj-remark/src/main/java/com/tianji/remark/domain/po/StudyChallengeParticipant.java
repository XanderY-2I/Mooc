package com.tianji.remark.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("study_challenge_participant")
public class StudyChallengeParticipant {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long challengeId;
    private Long userId;
    private Integer currentProgress;
    private Boolean completed;
    private LocalDateTime completedAt;
    private LocalDateTime joinTime;
}
