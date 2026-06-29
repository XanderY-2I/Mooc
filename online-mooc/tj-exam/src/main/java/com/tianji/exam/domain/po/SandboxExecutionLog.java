package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("sandbox_execution_log")
public class SandboxExecutionLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long submissionId;
    /** 1-执行步骤 2-stdout 3-stderr 4-系统 */
    private Integer logType;
    private String logContent;
    private Long timestampMs;
    private LocalDateTime createTime;
}
