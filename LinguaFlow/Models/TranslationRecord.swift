import Foundation
import SwiftData

@Model
final class TranslationRecord {
    var sourceText: String
    var translatedText: String
    var routeDescription: String
    var createdAt: Date

    init(sourceText: String, translatedText: String, route: TranslationRoute) {
        self.sourceText = sourceText
        self.translatedText = translatedText
        self.routeDescription = route.displayLabel
        self.createdAt = Date()
    }
}
