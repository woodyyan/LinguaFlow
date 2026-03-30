import Foundation

/// 本地简繁转换引擎
/// Apple Translation 不支持简↔繁（同语言对），所以用 macOS 内置的 CFStringTransform 做简繁转换
final class ChineseVariantConverter {

    /// 简体 → 繁体
    func simplifiedToTraditional(_ text: String) -> String {
        let mutable = NSMutableString(string: text)
        CFStringTransform(mutable, nil, "Hans-Hant" as CFString, false)
        return mutable as String
    }

    /// 繁体 → 简体
    func traditionalToSimplified(_ text: String) -> String {
        let mutable = NSMutableString(string: text)
        CFStringTransform(mutable, nil, "Hant-Hans" as CFString, false)
        return mutable as String
    }
}
