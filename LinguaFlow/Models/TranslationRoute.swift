import Foundation
import Translation

/// 翻译方向
enum TranslationRoute: Equatable {
    case englishToChinese       // 英 → 中
    case chineseToEnglish       // 中 → 英
    case simplifiedToCantonese  // 简 → 粤（繁体）
    case cantoneseToSimplified  // 粤（繁体）→ 简

    var displayLabel: String {
        switch self {
        case .englishToChinese:      return "English → 简体中文"
        case .chineseToEnglish:      return "简体中文 → English"
        case .simplifiedToCantonese: return "简体中文 → 繁體中文(粵語)"
        case .cantoneseToSimplified: return "繁體中文(粵語) → 简体中文"
        }
    }

    var sourceLanguage: Locale.Language {
        switch self {
        case .englishToChinese:      return Locale.Language(identifier: "en")
        case .chineseToEnglish:      return Locale.Language(identifier: "zh-Hans")
        case .simplifiedToCantonese: return Locale.Language(identifier: "zh-Hans")
        case .cantoneseToSimplified: return Locale.Language(identifier: "zh-Hant")
        }
    }

    var targetLanguage: Locale.Language {
        switch self {
        case .englishToChinese:      return Locale.Language(identifier: "zh-Hans")
        case .chineseToEnglish:      return Locale.Language(identifier: "en")
        case .simplifiedToCantonese: return Locale.Language(identifier: "zh-Hant")
        case .cantoneseToSimplified: return Locale.Language(identifier: "zh-Hans")
        }
    }

    /// 是否使用本地简繁转换（Apple Translation 不支持同语言对简↔繁）
    var usesLocalConversion: Bool {
        switch self {
        case .simplifiedToCantonese, .cantoneseToSimplified:
            return true
        case .englishToChinese, .chineseToEnglish:
            return false
        }
    }
}

/// 用户选择的翻译模式
enum TranslationMode: String, CaseIterable {
    case englishChinese = "英↔中"
    case cantonese      = "简↔粤"

    var icon: String {
        switch self {
        case .englishChinese: return "globe.americas"
        case .cantonese:      return "globe.asia.australia"
        }
    }
}
