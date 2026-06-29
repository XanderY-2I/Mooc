package com.tianji.chat.utils;

import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import java.io.File;
import java.io.IOException;

/**
 * 多格式内容解析工具 — 支持视频字幕、图文讲义(Markdown)、PDF 文档
 */
@Slf4j
public final class ContentParserUtils {

    private ContentParserUtils() {}

    // ================== 视频字幕解析 ==================

    /**
     * 解析 SRT/VTT 字幕文本，去除时间戳和序号，返回纯文本
     * 输入示例:
     *   1
     *   00:00:01,000 --> 00:00:04,000
     *   今天我们来学习Java多线程
     */
    public static String parseSubtitle(String rawSubtitle) {
        if (rawSubtitle == null || rawSubtitle.isBlank()) return "";

        StringBuilder result = new StringBuilder();
        for (String line : rawSubtitle.split("\\r?\\n")) {
            line = line.trim();
            if (line.isEmpty()) continue;
            // 跳过多余行：纯数字序号
            if (line.matches("^\\d+$")) continue;
            // 跳过时间戳行
            if (line.contains("-->")) continue;
            // 跳过 WebVTT 头
            if (line.startsWith("WEBVTT")) continue;
            // 去除 HTML 标签（VTT 可能有 <b> 等）
            line = line.replaceAll("<[^>]+>", "");
            // 去除花括号内样式标记
            line = line.replaceAll("\\{[^}]*\\}", "");
            if (!line.isBlank()) {
                result.append(line).append(" ");
            }
        }
        return result.toString().trim();
    }

    // ================== Markdown 讲义解析 ==================

    /**
     * 将 Markdown 讲义文本清洗为纯文本（去除图片链接、代码块标记等）
     * 保留标题标记以便分段
     */
    public static String cleanMarkdown(String markdown) {
        if (markdown == null || markdown.isBlank()) return "";

        return markdown
                // 去除图片 ![alt](url)
                .replaceAll("!\\[.*?]\\(.*?\\)", "[图片]")
                // 去除链接 [text](url) 保留文字
                .replaceAll("\\[(.*?)]\\(.*?\\)", "$1")
                // 去除行内代码
                .replaceAll("`{1,2}[^`]*`{1,2}", "")
                // 去除 HTML 标签
                .replaceAll("<[^>]+>", "")
                // 压缩连续空行
                .replaceAll("\\n{3,}", "\n\n")
                .trim();
    }

    /**
     * 按 Markdown 标题层级分段（用于更智能的切片）
     */
    public static java.util.List<String> splitByHeading(String markdown, int level) {
        java.util.List<String> sections = new java.util.ArrayList<>();
        if (markdown == null || markdown.isBlank()) return sections;

        String headingPattern = "^#{1," + level + "}\\s+.*$";
        String[] lines = markdown.split("\\r?\\n");
        StringBuilder current = new StringBuilder();
        String currentHeading = "";

        for (String line : lines) {
            if (line.matches(headingPattern)) {
                if (current.length() > 0) {
                    sections.add(currentHeading + "\n" + current.toString().trim());
                }
                currentHeading = line.trim();
                current = new StringBuilder();
            } else {
                current.append(line).append("\n");
            }
        }
        if (current.length() > 0) {
            sections.add(currentHeading + "\n" + current.toString().trim());
        }
        return sections;
    }

    // ================== PDF 解析 ==================

    /**
     * 解析 PDF 文件为纯文本
     * @param filePath PDF 文件路径
     * @return 解析后的文本
     */
    public static String parsePdf(String filePath) {
        File file = new File(filePath);
        if (!file.exists() || !file.isFile()) {
            log.warn("PDF文件不存在: {}", filePath);
            return "";
        }
        try (PDDocument document = PDDocument.load(file)) {
            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);
            return stripper.getText(document);
        } catch (IOException e) {
            log.error("PDF解析失败: {}", filePath, e);
            return "";
        }
    }

    /**
     * 解析 PDF 并按页分段
     */
    public static java.util.List<String> parsePdfByPage(String filePath) {
        java.util.List<String> pages = new java.util.ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return pages;

        try (PDDocument document = PDDocument.load(file)) {
            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);
            for (int i = 1; i <= document.getNumberOfPages(); i++) {
                stripper.setStartPage(i);
                stripper.setEndPage(i);
                String pageText = stripper.getText(document).trim();
                if (!pageText.isEmpty()) {
                    pages.add(pageText);
                }
            }
        } catch (IOException e) {
            log.error("PDF按页解析失败: {}", filePath, e);
        }
        return pages;
    }

    // ================== 内容类型检测 ==================

    /** 检测是否为 SRT/VTT 字幕格式 */
    public static boolean isSubtitleFormat(String text) {
        return text != null && text.contains("-->");
    }

    /** 检测是否为 Markdown 格式 */
    public static boolean isMarkdownFormat(String text) {
        return text != null && (text.contains("# ") || text.contains("```") || text.contains("**"));
    }
}
