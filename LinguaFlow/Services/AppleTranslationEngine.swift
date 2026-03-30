import Foundation
import Translation

/// 基于 Apple Translation Framework 的翻译引擎实现（macOS 15+）
///
/// Apple Translation API 通过 SwiftUI 的 `.translationTask` modifier 工作：
/// 1. 创建 `TranslationSession.Configuration`（指定源语言和目标语言）
/// 2. 在 View 上附加 `.translationTask(configuration)` modifier
/// 3. 在闭包中通过 `session.translate(text)` 执行翻译
///
/// 因此翻译逻辑需要配合 ViewModel 状态驱动来实现。
final class AppleTranslationEngine: TranslationEngine {

    func translate(_ text: String, route: TranslationRoute) async throws -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw TranslationError.emptyInput
        }

        // 注意：实际翻译调用由 SwiftUI 的 .translationTask 驱动
        // 这里抛出错误提示不应直接调用
        throw TranslationError.translationFailed(
            "Apple Translation 需要通过 SwiftUI .translationTask 调用"
        )
    }

    /// 构建翻译配置
    static func makeConfiguration(for route: TranslationRoute) -> TranslationSession.Configuration {
        TranslationSession.Configuration(
            source: route.sourceLanguage,
            target: route.targetLanguage
        )
    }
}
