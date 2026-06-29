package com.tianji.exam.domain.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@ApiModel("编程题详情（学生视角）")
public class SandboxQuestionVO {
    private Long id;
    private String name;
    private Integer questionType;
    private String language;
    @ApiModelProperty("代码模板（预填代码）")
    private String codeTemplate;
    @ApiModelProperty("填空标记")
    private List<Map<String, Object>> blankMarkers;
    @ApiModelProperty("标准输出（仅输出匹配题展示）")
    private String expectedOutput;
    private Integer timeLimitMs;
    private Integer memoryLimitKb;
    private Integer difficulty;
    private Integer score;
    @ApiModelProperty("示例用例（学生可见）")
    private List<TestCaseItem> sampleCases;

    @Data
    public static class TestCaseItem {
        private Long id;
        private Integer caseIndex;
        private String inputData;
        private String expectedOutput;
    }
}
