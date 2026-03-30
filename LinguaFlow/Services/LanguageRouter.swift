import Foundation
import NaturalLanguage

/// 语言检测 + 翻译路由服务
final class LanguageRouter {
    private let recognizer = NLLanguageRecognizer()

    /// 根据输入文本和用户选择的模式，确定翻译方向
    func detectRoute(for text: String, mode: TranslationMode) -> TranslationRoute {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // 空文本时返回默认方向
            return mode == .cantonese ? .simplifiedToCantonese : .englishToChinese
        }

        recognizer.reset()
        recognizer.processString(text)

        guard let dominant = recognizer.dominantLanguage else {
            // 无法识别时按模式给默认值
            return mode == .cantonese ? .simplifiedToCantonese : .englishToChinese
        }

        switch mode {
        case .englishChinese:
            // 英↔中模式
            if dominant == .english {
                return .englishToChinese
            } else {
                return .chineseToEnglish
            }

        case .cantonese:
            // 简↔粤模式
            if dominant == .traditionalChinese {
                // 繁体 → 视为粤语输入 → 翻成简体
                return .cantoneseToSimplified
            } else {
                // 简体或其他 → 翻成粤语
                return .simplifiedToCantonese
            }
        }
    }

    /// 获取语言检测的置信度（调试用）
    func detectLanguageHypotheses(for text: String, maxCount: Int = 5) -> [(NLLanguage, Double)] {
        recognizer.reset()
        recognizer.processString(text)
        let hypotheses = recognizer.languageHypotheses(withMaximum: maxCount)
        return hypotheses.sorted { $0.value > $1.value }
    }
}
