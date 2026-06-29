package com.tianji.data.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("rec_course_similarity")
public class RecCourseSimilarity {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseIdA;
    private Long courseIdB;
    private BigDecimal similarity;
    private Integer similarityType;
    private LocalDateTime updateTime;
}
