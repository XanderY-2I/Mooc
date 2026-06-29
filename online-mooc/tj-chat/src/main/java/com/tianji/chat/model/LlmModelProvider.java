package com.tianji.chat.model;

import dev.langchain4j.data.message.ChatMessage;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.chat.StreamingChatLanguageModel;
import dev.langchain4j.model.embedding.EmbeddingModel;

import java.util.List;

/**
 * LLM 模型提供者抽象接口 — 支持替换底层模型实现而不影响上层业务逻辑
 * 当前实现：OpenAiModelProvider（兼容 OpenAI API 协议）
 * 可扩展：OllamaModelProvider、LocalLlmModelProvider 等
 */
public interface LlmModelProvider {

    /** 阻塞式聊天模型 */
    ChatLanguageModel chatModel();

    /** 流式聊天模型 */
    StreamingChatLanguageModel streamingChatModel();

    /** 嵌入模型（用于向量化） */
    EmbeddingModel embeddingModel();

    /** 获取模型名称（用于日志/统计） */
    String modelName();

    /** 估算 token 数（用于分段策略和成本控制） */
    int estimateTokens(String text);
}
