package com.tianji.data.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 学习分析事件类型枚举 — 覆盖完整的用户学习生命周期
 */
@Getter
@AllArgsConstructor
public enum LearningEventEnum {

    // === 曝光 Exposure ===
    COURSE_LIST_VIEW("course_list_view", "课程列表曝光", EventCategory.EXPOSURE),
    COURSE_DETAIL_VIEW("course_detail_view", "课程详情页浏览", EventCategory.EXPOSURE),

    // === 点击/互动 Click ===
    COURSE_DETAIL_CTA_CLICK("course_detail_cta_click", "课程详情CTA点击", EventCategory.CLICK),
    SEARCH_COURSE("search_course", "搜索课程", EventCategory.CLICK),
    RECOMMEND_CLICK("recommend_click", "推荐位点击", EventCategory.CLICK),

    // === 购买 Purchase ===
    COURSE_PURCHASE_START("course_purchase_start", "购买流程发起", EventCategory.PURCHASE),
    COURSE_PURCHASE_SUCCESS("course_purchase_success", "购买成功", EventCategory.PURCHASE),
    COURSE_REFUND("course_refund", "课程退课", EventCategory.PURCHASE),

    // === 学习 Learning ===
    LESSON_START("lesson_start", "小节开始学习", EventCategory.LEARNING),
    LESSON_PROGRESS("lesson_progress", "小节学习进度更新", EventCategory.LEARNING),
    LESSON_COMPLETE("lesson_complete", "小节完成", EventCategory.LEARNING),
    CHAPTER_COMPLETE("chapter_complete", "章节完成", EventCategory.LEARNING),
    COURSE_COMPLETE("course_complete", "课程完成", EventCategory.LEARNING),
    EXERCISE_SUBMIT("exercise_submit", "练习题提交", EventCategory.LEARNING),
    ;

    private final String code;
    private final String name;
    private final EventCategory category;

    @Getter
    @AllArgsConstructor
    public enum EventCategory {
        EXPOSURE("exposure", "曝光"),
        CLICK("click", "点击/互动"),
        PURCHASE("purchase", "购买"),
        LEARNING("learning", "学习"),
        RETENTION("retention", "留存");
        private final String code;
        private final String name;
    }

    public static LearningEventEnum fromCode(String code) {
        for (LearningEventEnum e : values()) {
            if (e.code.equals(code)) return e;
        }
        return null;
    }
}
