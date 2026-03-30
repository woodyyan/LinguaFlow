import SwiftUI
import SwiftData

@main
struct LinguaFlowApp: App {
    var body: some Scene {
        WindowGroup {
            MainTranslationView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 600, height: 520)
        .windowResizability(.contentSize)
    }
}
