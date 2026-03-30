import SwiftUI

/// 翻译模式切换组件
struct ModeToggle: View {
    @Binding var selectedMode: TranslationMode
    let onModeChange: (TranslationMode) -> Void

    var body: some View {
        HStack(spacing: 2) {
            ForEach(TranslationMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedMode = mode
                        onModeChange(mode)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 12))
                        Text(mode.rawValue)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedMode == mode
                                  ? Color.accentColor.opacity(0.15)
                                  : Color.clear)
                    )
                    .foregroundColor(selectedMode == mode
                                    ? .accentColor
                                    : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}
