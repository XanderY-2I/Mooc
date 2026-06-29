package com.tianji.exam.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("sandbox_test_case")
public class SandboxTestCase {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long questionId;
    private Integer caseIndex;
    private String inputData;
    private String expectedOutput;
    private Boolean isHidden;
    private Boolean isSample;
    private BigDecimal scoreWeight;
    /** 比对模式: 1-精确 2-忽略空白 3-正则 4-自定义脚本 */
    private Integer compareMode;
    private String compareScript;
    private LocalDateTime createTime;
}
