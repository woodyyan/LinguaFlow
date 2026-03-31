import Foundation
import SwiftUI
import Translation
import Combine

/// 主翻译 ViewModel
@MainActor
final class TranslationViewModel: ObservableObject {

    // MARK: - Published State

    @Published var sourceText: String = ""
    @Published var translatedText: String = ""
    @Published var mode: TranslationMode = .englishChinese
    @Published var currentRoute: TranslationRoute = .englishToChinese
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    @Published var showCopiedToast: Bool = false

    // MARK: - Apple Translation Request（仅英↔中使用）

    @Published var translationRequest: TranslationRequest?

    struct TranslationRequest: Equatable {
        let id: UUID
        let text: String
        let route: TranslationRoute

        init(text: String, route: TranslationRoute) {
            self.id = UUID()
            self.text = text
            self.route = route
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    // MARK: - Private

    private let languageRouter = LanguageRouter()
    private let chineseConverter = ChineseVariantConverter()
    private let debouncer = Debouncer(delay: 0.8)

    // MARK: - Public Methods

    func onSourceTextChanged() {
        let text = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            translatedText = ""
            errorMessage = nil
            isTranslating = false
            debouncer.cancel()
            currentRoute = mode == .traditional ? .simplifiedToTraditional : .englishToChinese
            return
        }

        currentRoute = languageRouter.detectRoute(for: text, mode: mode)

        debouncer.debounce { [weak self] in
            self?.submitTranslation()
        }
    }

    func submitTranslation() {
        let text = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        debouncer.cancel()
        currentRoute = languageRouter.detectRoute(for: text, mode: mode)
        isTranslating = true
        errorMessage = nil

        if currentRoute.usesLocalConversion {
            // 简↔繁：用本地 CFStringTransform，即时完成
            performLocalConversion(text: text, route: currentRoute)
        } else {
            // 英↔中：走 Apple Translation
            translationRequest = TranslationRequest(text: text, route: currentRoute)
        }
    }

    func switchMode(to newMode: TranslationMode) {
        mode = newMode
        let text = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            currentRoute = languageRouter.detectRoute(for: text, mode: mode)
            submitTranslation()
        } else {
            currentRoute = mode == .traditional ? .simplifiedToTraditional : .englishToChinese
            translatedText = ""
        }
    }

    /// 由 .translationTask 的回调执行 Apple Translation（仅英↔中）
    func performAppleTranslation(using session: TranslationSession) async {
        guard let request = translationRequest else {
            isTranslating = false
            return
        }

        do {
            try await session.prepareTranslation()
            let response = try await session.translate(request.text)
            if translationRequest?.id == request.id {
                translatedText = response.targetText
                errorMessage = nil
            }
        } catch is CancellationError {
            // 被取消，忽略
        } catch {
            if translationRequest?.id == request.id {
                errorMessage = "翻译失败: \(error.localizedDescription)"
            }
        }

        if translationRequest?.id == request.id {
            isTranslating = false
        }
    }

    func copyTranslation() {
        guard !translatedText.isEmpty else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(translatedText, forType: .string)

        showCopiedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.showCopiedToast = false
        }
    }

    func clearAll() {
        sourceText = ""
        translatedText = ""
        errorMessage = nil
        isTranslating = false
        translationRequest = nil
        debouncer.cancel()
    }

    func swapTexts() {
        guard !translatedText.isEmpty else { return }
        let temp = translatedText
        sourceText = temp
        translatedText = ""
        submitTranslation()
    }

    // MARK: - Private

    /// 本地简繁转换（即时完成，不走 Apple Translation）
    private func performLocalConversion(text: String, route: TranslationRoute) {
        switch route {
        case .simplifiedToTraditional:
            translatedText = chineseConverter.simplifiedToTraditional(text)
        case .traditionalToSimplified:
            translatedText = chineseConverter.traditionalToSimplified(text)
        default:
            break
        }
        errorMessage = nil
        isTranslating = false
    }
}
