package com.tianji.chat.service;

import com.tianji.chat.domain.dto.*;
import com.tianji.chat.domain.vo.*;
import com.tianji.common.domain.dto.PageDTO;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

/**
 * AI 学习助手核心服务
 */
public interface IAiAssistantService {

    // ========= 核心交互 =========

    /** 课程问答 / 通用提问 — 流式 */
    SseEmitter askStream(AiAskRequest request);

    /** 课程问答 — 阻塞式 */
    AiAnswerVO askBlocking(AiAskRequest request);

    /** 生成知识点总结 — 流式 */
    SseEmitter summarizeStream(SummaryRequest request);

    /** 生成练习题 */
    List<ExerciseVO> generateExercises(ExerciseGenRequest request);

    /** 错题讲解 */
    SseEmitter explainErrorsStream(ErrorAnalysisRequest request);

    /** 学习路径建议 */
    LearningPathVO suggestLearningPath(LearningPathRequest request);

    // ========= 对话管理 =========

    /** 获取对话历史 */
    PageDTO<ConversationVO> getConversationHistory(String sessionId, int pageNo, int pageSize);

    /** 获取用户会话列表 */
    List<SessionVO> listSessions();

    /** 获取单条对话详情 */
    AiAnswerVO getConversationDetail(Long conversationId);

    /** 删除会话 */
    void deleteSession(String sessionId);

    /** 为对话评分 */
    void rateConversation(Long conversationId, int rating);
}
