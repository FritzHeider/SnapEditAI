#if canImport(SwiftUI)
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "AI-Powered Editing",
            subtitle: "Transform raw footage into viral content with smart trimming, captions, and effects",
            icon: "wand.and.stars",
            color: .purple
        ),
        OnboardingPage(
            title: "Viral-Ready Templates",
            subtitle: "Choose from trending templates optimized for TikTok, Reels, and YouTube Shorts",
            icon: "square.grid.2x2",
            color: .pink
        ),
        OnboardingPage(
            title: "One-Tap Publishing",
            subtitle: "Export and share directly to your favorite platforms with optimal timing",
            icon: "paperplane.fill",
            color: .blue
        )
    ]
    
    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? Color.white : Color.gray.opacity(0.4))
                                .frame(width: currentPage == index ? 20 : 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }

                    VStack(spacing: 12) {
                        if currentPage < pages.count - 1 {
                            Button("Continue") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Button("Skip") {
                                completeOnboarding()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        } else {
                            Button("Get Started") {
                                completeOnboarding()
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Button("Start Free Trial") {
                                appState.isPremiumUser = true
                                completeOnboarding()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
    
    private func completeOnboarding() {
        withAnimation {
            appState.isOnboardingComplete = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundColor(page.color)
            }
            
            // Text Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.purple, .pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}

#endif
