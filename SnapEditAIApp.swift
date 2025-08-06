#if canImport(SwiftUI)
import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
#endif

@main
struct SnapEditAIApp: App {
    @StateObject private var appState = AppState()

    init() {
        AnalyticsManager.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
