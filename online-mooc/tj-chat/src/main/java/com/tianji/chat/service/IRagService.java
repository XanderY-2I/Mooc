package com.tianji.chat.service;

import com.tianji.chat.domain.po.AiKnowledgeChunk;
import dev.langchain4j.data.segment.TextSegment;

import java.util.List;
import java.util.Map;

/**
 * RAG 检索增强生成服务 — 负责向量检索、分段策略、召回与重排
 */
public interface IRagService {

    /**
     * 将课程相关内容向量化后存入 Qdrant 和 MySQL 索引
     *
     * @param courseId    课程ID
     * @param sectionId   小节ID（可为 null）
     * @param contentType 内容类型 1-介绍 2-讲义 3-字幕 4-PDF 5-题目 6-评论
     * @param docId       来源文档标识
     * @param title       分段标题
     * @param content     原始文本
     */
    void indexContent(Long courseId, Long sectionId, int contentType,
                      String docId, String title, String content);

    /**
     * 批量索引内容 — 对大文本自动分段
     */
    void indexContentBatch(Long courseId, Long sectionId, int contentType,
                           String docId, String title, String content,
                           int chunkSize, int overlapSize);

    /**
     * 混合检索：向量相似度 + 关键词匹配
     *
     * @param query    查询文本
     * @param courseId 限定课程ID（可选）
     * @param topK     召回数量
     * @return 排序后的检索结果，按 relevance 降序
     */
    List<RagHit> search(String query, Long courseId, int topK);

    /**
     * 根据 docId 清除旧索引
     */
    void removeByDocId(String docId);

    /**
     * 由检索命中结果拼接 LLM 上下文
     */
    String buildContext(List<RagHit> hits, int maxTokens);

    /**
     * 检索命中结果
     */
    class RagHit {
        public String docId;
        public String title;
        public String content;
        public double vectorScore;
        public int contentType;
        public Long courseId;
        public Long sectionId;

        public RagHit(String docId, String title, String content, double vectorScore,
                      int contentType, Long courseId, Long sectionId) {
            this.docId = docId;
            this.title = title;
            this.content = content;
            this.vectorScore = vectorScore;
            this.contentType = contentType;
            this.courseId = courseId;
            this.sectionId = sectionId;
        }
    }
}
