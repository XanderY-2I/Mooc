package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("sandbox_submission")
public class SandboxSubmission {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long questionId;
    private Long courseId;
    private Long sectionId;
    private String language;
    private String sourceCode;
    /** 0-排队 1-编译中 2-运行中 3-完成 4-编译错误 5-超时 6-运行错误 7-系统错误 */
    private Integer status;
    private Integer totalScore;
    private Integer passedCases;
    private Integer totalCases;
    private String compileErrorMsg;
    private Integer execDurationMs;
    private Integer execMemoryKb;
    private LocalDateTime submitTime;
    private LocalDateTime finishTime;
}
