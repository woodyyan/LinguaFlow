import Foundation
import Translation

/// 翻译引擎协议 —— 方便后续切换不同实现
protocol TranslationEngine {
    func translate(_ text: String, route: TranslationRoute) async throws -> String
}

/// 翻译引擎错误
enum TranslationError: LocalizedError {
    case emptyInput
    case translationFailed(String)
    case languageNotSupported

    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "请输入需要翻译的文本"
        case .translationFailed(let msg):
            return "翻译失败: \(msg)"
        case .languageNotSupported:
            return "不支持的语言组合"
        }
    }
}
