import SwiftUI

/// 语言检测指示器
struct LanguageIndicator: View {
    let route: TranslationRoute
    let isTranslating: Bool

    var body: some View {
        HStack(spacing: 8) {
            if isTranslating {
                ProgressView()
                    .controlSize(.small)
                    .scaleEffect(0.7)
                Text("翻译中...")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "arrow.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.accentColor)
                Text(route.displayLabel)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isTranslating)
        .animation(.easeInOut(duration: 0.15), value: route)
    }
}
