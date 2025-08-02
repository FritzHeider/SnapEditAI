import Foundation
#if canImport(FirebaseCore)
import FirebaseCore
#endif
#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif
#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

/// Centralized helper for analytics and crash reporting.
final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}

    /// Configures Firebase services if available.
    func setup() {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        #endif
    }

    func logOnboardingCompleted() {
        logEvent(name: "onboarding_complete")
    }

    func logExport() {
        logEvent(name: "export_video")
    }

    func logPaywallView() {
        logEvent(name: "paywall_view")
    }

    func logUpgrade() {
        logEvent(name: "upgrade")
    }

    func setSubscriptionStatus(isPremium: Bool) {
        setUserProperty(isPremium ? "premium" : "free", forName: "subscription_status")
    }

    func setExportCount(_ count: Int) {
        setUserProperty("\(count)", forName: "export_count")
    }

    private func logEvent(name: String, parameters: [String: Any]? = nil) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(name, parameters: parameters)
        #endif
    }

    private func setUserProperty(_ value: String?, forName name: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.setUserProperty(value, forName: name)
        #endif
    }

    func recordCrash(_ message: String) {
        #if canImport(FirebaseCrashlytics)
        Crashlytics.crashlytics().log(message)
        #endif
    }
}

