package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Map;

@Data
@Accessors(chain = true)
@TableName(value = "sandbox_question", autoResultMap = true)
public class SandboxQuestion {
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    /** 编程语言: java/python/cpp/c/go/javascript */
    private String language;

    /** 题型: 1-单文件代码 2-填空补全 3-输出匹配 4-综合实验 */
    private Integer questionType;

    /** 代码模板（预填代码） */
    private String codeTemplate;

    /** 填空标记 [{"id":1,"line":5,"desc":"补充循环体"}] */
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<Map<String, Object>> blankMarkers;

    /** 标准输出（输出匹配题） */
    private String expectedOutput;

    private Integer timeLimitMs;
    private Integer memoryLimitKb;
    private String runCommand;
    private String buildCommand;
    private Boolean allowNetwork;
}
