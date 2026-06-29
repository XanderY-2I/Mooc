package com.tianji.exam.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("测试用例DTO")
public class TestCaseDTO {
    private Long id;
    private Long questionId;
    private Integer caseIndex;
    private String inputData;
    private String expectedOutput;
    private Boolean isHidden;
    private Boolean isSample;
    private BigDecimal scoreWeight;
    private Integer compareMode;
    private String compareScript;
}
