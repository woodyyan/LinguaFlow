import SwiftUI

/// 自定义文本输入区域
struct TextInputArea: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isEditable: Bool
    let onTextChange: (() -> Void)?

    init(
        title: String,
        text: Binding<String>,
        placeholder: String = "",
        isEditable: Bool = true,
        onTextChange: (() -> Void)? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.isEditable = isEditable
        self.onTextChange = onTextChange
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)

            ZStack(alignment: .topLeading) {
                if isEditable {
                    TextEditor(text: $text)
                        .font(.system(size: 15))
                        .scrollContentBackground(.hidden)
                        .padding(8)
                        .onChange(of: text) { _, _ in
                            onTextChange?()
                        }
                } else {
                    ScrollView {
                        Text(text)
                            .font(.system(size: 15))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(12)
                    }
                }

                // Placeholder
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(isEditable ? 16 : 12)
                        .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(nsColor: .textBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
            )
        }
    }
}
