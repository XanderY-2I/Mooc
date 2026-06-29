package com.tianji.chat.model;

import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.chat.StreamingChatLanguageModel;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.openai.OpenAiChatModel;
import dev.langchain4j.model.openai.OpenAiEmbeddingModel;
import dev.langchain4j.model.openai.OpenAiStreamingChatModel;
import dev.langchain4j.model.openai.OpenAiTokenizer;

import java.time.Duration;

/**
 * OpenAI 协议兼容模型提供者（通义千问 / DeepSeek / GPT 等均适用）
 */
public class OpenAiModelProvider implements LlmModelProvider {

    private final String baseUrl;
    private final String apiKey;
    private final String modelName;
    private final int maxTokens;
    private final int timeoutSeconds;
    private final int maxRetries;
    private final double chatTemperature;
    private final double streamingTemperature;
    private final OpenAiTokenizer tokenizer;

    public OpenAiModelProvider(String baseUrl, String apiKey, String modelName,
                               int maxTokens, int timeoutSeconds, int maxRetries,
                               double chatTemperature, double streamingTemperature) {
        this.baseUrl = baseUrl;
        this.apiKey = apiKey;
        this.modelName = modelName;
        this.maxTokens = maxTokens;
        this.timeoutSeconds = timeoutSeconds;
        this.maxRetries = maxRetries;
        this.chatTemperature = chatTemperature;
        this.streamingTemperature = streamingTemperature;
        this.tokenizer = new OpenAiTokenizer();
    }

    @Override
    public ChatLanguageModel chatModel() {
        return OpenAiChatModel.builder()
                .baseUrl(baseUrl).apiKey(apiKey)
                .temperature(chatTemperature).maxTokens(maxTokens)
                .tokenizer(tokenizer)
                .timeout(Duration.ofSeconds(timeoutSeconds))
                .modelName(modelName).maxRetries(maxRetries)
                .build();
    }

    @Override
    public StreamingChatLanguageModel streamingChatModel() {
        return OpenAiStreamingChatModel.builder()
                .baseUrl(baseUrl).apiKey(apiKey)
                .temperature(streamingTemperature).maxTokens(maxTokens)
                .tokenizer(tokenizer)
                .timeout(Duration.ofSeconds(timeoutSeconds))
                .modelName(modelName)
                .build();
    }

    @Override
    public EmbeddingModel embeddingModel() {
        return OpenAiEmbeddingModel.builder()
                .baseUrl(baseUrl).apiKey(apiKey)
                .timeout(Duration.ofSeconds(timeoutSeconds))
                .modelName(modelName)
                .build();
    }

    @Override
    public String modelName() {
        return modelName;
    }

    @Override
    public int estimateTokens(String text) {
        return tokenizer.estimateTokenCountInText(text);
    }
}
