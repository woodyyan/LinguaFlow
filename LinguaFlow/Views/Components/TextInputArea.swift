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

            Group {
                if isEditable {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .font(.system(size: 15))
                        .textFieldStyle(.plain)
                        .lineLimit(5...20)
                        .onChange(of: text) { _, _ in
                            onTextChange?()
                        }
                } else {
                    ScrollView {
                        if text.isEmpty {
                            Text(placeholder)
                                .font(.system(size: 15))
                                .foregroundColor(.secondary.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        } else {
                            Text(text)
                                .font(.system(size: 15))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
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
