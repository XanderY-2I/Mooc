package com.tianji.data.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@ApiModel("章节留存/流失分析")
public class ChapterRetentionVO {
    @ApiModelProperty("课程ID")
    private Long courseId;
    @ApiModelProperty("课程名称")
    private String courseName;
    @ApiModelProperty("章节留存列表")
    private List<ChapterItem> chapters;

    @Data
    public static class ChapterItem {
        @ApiModelProperty("章序号")
        private Integer chapterIndex;
        @ApiModelProperty("章名称")
        private String chapterName;
        @ApiModelProperty("小节数")
        private Integer sectionCount;
        @ApiModelProperty("进入人数")
        private Long enterUv;
        @ApiModelProperty("完成人数")
        private Long completeUv;
        @ApiModelProperty("流失人数")
        private Long dropOffUv;
        @ApiModelProperty("留存率(%)")
        private BigDecimal retentionRate;
    }
}
