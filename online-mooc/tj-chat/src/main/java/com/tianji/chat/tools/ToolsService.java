package com.tianji.chat.tools;

import com.tianji.api.client.course.CourseClient;
import com.tianji.api.client.exam.ExamClient;
import com.tianji.api.client.learning.LearningClient;
import com.tianji.api.client.remark.RemarkClient;
import com.tianji.api.client.search.SearchClient;
import com.tianji.api.dto.course.CourseSimpleInfoDTO;
import com.tianji.api.dto.exam.QuestionDTO;
import com.tianji.api.dto.leanring.LearningLessonDTO;
import com.tianji.api.dto.leanring.LearningRecordDTO;
import com.tianji.chat.domain.vo.CourseVO;
import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
@Slf4j
public class ToolsService {

    @Autowired
    private SearchClient searchClient;
    @Autowired
    private CourseClient courseClient;
    @Autowired
    private ExamClient examClient;
    @Autowired
    private LearningClient learningClient;

    @Tool("对给定的 2 个数字求和")
    double sum(double a, double b) {
        return a + b;
    }

    @Tool("返回给定数字的平方根")
    double squareRoot(double x) {
        return Math.sqrt(x);
    }

    @Tool("根据课程名称搜索课程，返回课程ID、名称和价格")
    public List<CourseVO> queryCourse(@P(value = "课程名称") String name) {
        List<Long> longs = searchClient.queryCoursesIdByName(name);
        List<CourseSimpleInfoDTO> courseSearchDTOS = courseClient.getSimpleInfoList(longs);
        List<CourseVO> voList = new ArrayList<>();
        for (CourseSimpleInfoDTO courseSearchDTO : courseSearchDTOS) {
            CourseVO courseVO = new CourseVO();
            courseVO.setId(courseSearchDTO.getId());
            courseVO.setName(courseSearchDTO.getName());
            courseVO.setPrice(courseSearchDTO.getPrice());
            voList.add(courseVO);
        }
        log.info("查询课程：{}", courseSearchDTOS);
        return voList;
    }

    @Tool("根据课程ID查询课程详情，包括课程名称、价格等信息")
    public CourseVO getCourseDetail(@P(value = "课程ID") Long courseId) {
        List<CourseSimpleInfoDTO> infos = courseClient.getSimpleInfoList(
                java.util.Collections.singletonList(courseId));
        if (infos != null && !infos.isEmpty()) {
            CourseSimpleInfoDTO info = infos.get(0);
            CourseVO vo = new CourseVO();
            vo.setId(info.getId());
            vo.setName(info.getName());
            vo.setPrice(info.getPrice());
            return vo;
        }
        return null;
    }

    @Tool("查询用户某门课程的学习进度，返回学习小节数、完成率等信息")
    public String getLearningProgress(@P(value = "课程ID") Long courseId) {
        try {
            LearningLessonDTO lesson = learningClient.queryLearningRecordByCourse(courseId);
            if (lesson == null) return "该课程暂无学习记录";
            List<LearningRecordDTO> records = lesson.getRecords();
            long finished = records != null ? records.stream().filter(r -> r.getFinished() != null && r.getFinished()).count() : 0;
            long total = records != null ? records.size() : 0;
            return String.format("课程学习进度：已完成 %d/%d 个小节（%.1f%%）",
                    finished, total, total > 0 ? (finished * 100.0 / total) : 0);
        } catch (Exception e) {
            log.warn("查询学习进度失败: courseId={}", courseId, e);
            return "暂时无法获取学习进度";
        }
    }

    @Tool("根据题目ID列表查询题目详情，包含题干、选项和正确答案")
    public List<QuestionDTO> getQuestionsByIds(@P(value = "题目ID列表") List<Long> ids) {
        if (ids == null || ids.isEmpty()) return new ArrayList<>();
        return examClient.queryQuestionByIds(ids);
    }

    @Tool("搜索课程相关的常见问题和讨论")
    public String searchCourseFaq(@P(value = "搜索关键词") String keyword) {
        List<Long> courseIds = searchClient.queryCoursesIdByName(keyword);
        if (courseIds == null || courseIds.isEmpty()) {
            return "未找到与" + keyword + "相关的课程";
        }
        return "找到 " + courseIds.size() + " 个相关课程，可以在课程页面查看详细问题和讨论";
    }
}

