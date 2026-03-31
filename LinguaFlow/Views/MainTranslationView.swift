import SwiftUI
import Translation

/// 主翻译界面
struct MainTranslationView: View {
    @StateObject private var viewModel = TranslationViewModel()

    /// 翻译配置 —— @State 驱动 .translationTask
    @State private var translationConfig: TranslationSession.Configuration?

    var body: some View {
        VStack(spacing: 0) {
            headerBar

            Divider()

            VStack(spacing: 14) {
                // 输入区
                TextInputArea(
                    title: "输入",
                    text: $viewModel.sourceText,
                    placeholder: placeholderText,
                    isEditable: true,
                    onTextChange: {
                        viewModel.onSourceTextChanged()
                    }
                )

                // 中间操作栏
                middleBar

                // 输出区
                ZStack(alignment: .bottomTrailing) {
                    TextInputArea(
                        title: "翻译",
                        text: .constant(viewModel.translatedText),
                        placeholder: "翻译结果将显示在这里...",
                        isEditable: false
                    )

                    if !viewModel.translatedText.isEmpty {
                        copyButton
                            .padding(12)
                    }
                }

                // 错误信息
                if let error = viewModel.errorMessage {
                    errorBanner(message: error)
                }
            }
            .padding(20)
        }
        .frame(minWidth: 500, minHeight: 460)
        .background(Color(nsColor: .windowBackgroundColor))
        // 监听 Apple Translation 请求（仅英↔中使用）
        .onChange(of: viewModel.translationRequest) { oldVal, newVal in
            guard let request = newVal else { return }
            // 简↔繁不走 Apple Translation
            guard !request.route.usesLocalConversion else { return }

            let oldRoute = oldVal?.route
            let newRoute = request.route
            let languagePairChanged = oldRoute != newRoute

            if translationConfig == nil || languagePairChanged {
                translationConfig = nil
                DispatchQueue.main.async {
                    translationConfig = TranslationSession.Configuration(
                        source: newRoute.sourceLanguage,
                        target: newRoute.targetLanguage
                    )
                }
            } else {
                translationConfig?.invalidate()
            }
        }
        // Apple Translation Task（仅英↔中）
        .translationTask(translationConfig) { session in
            await viewModel.performAppleTranslation(using: session)
        }
        // 键盘快捷键：回车立即翻译
        .onSubmit {
            viewModel.submitTranslation()
        }
        // ⌘/ 切换模式（隐藏按钮承载快捷键）
        .background {
            Button("") {
                let next: TranslationMode = viewModel.mode == .englishChinese ? .traditional : .englishChinese
                viewModel.switchMode(to: next)
            }
            .keyboardShortcut("/", modifiers: .command)
            .hidden()
            // ⌘ Shift C 复制翻译结果
            Button("") {
                viewModel.copyTranslation()
            }
            .keyboardShortcut("c", modifiers: [.command, .shift])
            .hidden()
        }
        // 复制成功 Toast
        .overlay(alignment: .bottom) {
            if viewModel.showCopiedToast {
                copiedToast
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showCopiedToast)
    }

    // MARK: - Sub Views

    private var headerBar: some View {
        HStack {
            Text("LinguaFlow")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)

            Spacer()

            ModeToggle(
                selectedMode: $viewModel.mode,
                onModeChange: { newMode in
                    viewModel.switchMode(to: newMode)
                }
            )

            Spacer()

            Button(action: { viewModel.clearAll() }) {
                Image(systemName: "trash")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .help("清空所有内容")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    private var middleBar: some View {
        HStack {
            LanguageIndicator(
                route: viewModel.currentRoute,
                isTranslating: viewModel.isTranslating
            )

            Spacer()

            // 手动翻译按钮
            Button(action: { viewModel.submitTranslation() }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.forward.circle.fill")
                        .font(.system(size: 14))
                    Text("翻译")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.return, modifiers: .command)
            .help("翻译 (⌘ Return)")
            .disabled(viewModel.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            // 交换按钮
            Button(action: { viewModel.swapTexts() }) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.accentColor)
                    .padding(6)
                    .background(
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                    )
            }
            .buttonStyle(.plain)
            .help("交换输入和输出")
            .disabled(viewModel.translatedText.isEmpty)
        }
    }

    private var copyButton: some View {
        Button(action: { viewModel.copyTranslation() }) {
            HStack(spacing: 4) {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 11))
                Text("复制")
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.accentColor)
            )
            .foregroundColor(.white)
        }
        .buttonStyle(.plain)
    }

    private func errorBanner(message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 13))
            Text(message)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.08))
        )
    }

    private var copiedToast: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 13))
            Text("已复制到剪贴板")
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
        )
    }

    private var placeholderText: String {
        switch viewModel.mode {
        case .englishChinese:
            return "输入英文或中文..."
        case .traditional:
            return "输入简体中文或繁体中文..."
        }
    }
}

#Preview {
    MainTranslationView()
        .frame(width: 600, height: 520)
}
