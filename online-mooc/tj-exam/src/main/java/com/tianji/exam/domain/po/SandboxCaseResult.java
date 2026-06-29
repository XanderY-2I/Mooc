package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("sandbox_case_result")
public class SandboxCaseResult {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long submissionId;
    private Long caseId;
    private Integer caseIndex;
    private Boolean isPassed;
    private String actualOutput;
    private String errorOutput;
    private Integer execDurationMs;
    private Integer execMemoryKb;
    private Integer exitCode;
    private Integer score;
    private LocalDateTime createTime;
}
