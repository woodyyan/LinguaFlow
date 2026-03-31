import Foundation
import NaturalLanguage

/// 语言检测 + 翻译路由服务
final class LanguageRouter {
    private let recognizer = NLLanguageRecognizer()

    /// 根据输入文本和用户选择的模式，确定翻译方向
    func detectRoute(for text: String, mode: TranslationMode) -> TranslationRoute {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return mode == .traditional ? .simplifiedToTraditional : .englishToChinese
        }

        recognizer.reset()
        recognizer.processString(text)

        guard let dominant = recognizer.dominantLanguage else {
            return mode == .traditional ? .simplifiedToTraditional : .englishToChinese
        }

        switch mode {
        case .englishChinese:
            if dominant == .english {
                return .englishToChinese
            } else {
                return .chineseToEnglish
            }

        case .traditional:
            if dominant == .traditionalChinese {
                return .traditionalToSimplified
            } else {
                return .simplifiedToTraditional
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
