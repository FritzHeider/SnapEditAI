#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if !appState.isOnboardingComplete {
                OnboardingView()
            } else {
                MainTabView(selectedTab: $selectedTab)
            }
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            EditorView()
                .tabItem {
                    Image(systemName: "scissors")
                    Text("Edit")
                }
                .tag(1)

            TemplatesView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Templates")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingVideoPicker = false
    @State private var showingPurchaseError = false

    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerSection
                        quickActionsSection
                        recentProjectsSection

                        if !appState.isPremiumUser {
                            UsageStatsCard()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingVideoPicker) {
            VideoPickerView()
        }
        .alert("Purchase Failed", isPresented: $showingPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(appState.subscriptionManager.lastError ?? "Unknown error")
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Good to see you")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("SnapEdit AI")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Spacer()

                if !appState.isPremiumUser {
                    Button {
                        AnalyticsManager.shared.logPaywallView()
                        Task {
                            let success = await appState.subscriptionManager.purchase()
                            if !success {
                                showingPurchaseError = true
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                            Text("Go Pro")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                    }
                    .background(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.purple.opacity(0.4), radius: 8, x: 0, y: 6)
                }
            }

            Text("Shoot. Speak. Sparkle. Go viral in under 60 seconds.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    private var quickActionsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingVideoPicker = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 44, height: 44)
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Create New Video")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Start with a clip or record instantly")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.white)
                }
            }
            .glassCard()

            HStack(spacing: 12) {
                QuickActionCard(icon: "camera.fill", title: "Record", subtitle: "New video")
                QuickActionCard(icon: "photo.on.rectangle", title: "Import", subtitle: "From gallery")
                QuickActionCard(icon: "wand.and.stars", title: "AI Magic", subtitle: "Auto-edit")
            }
        }
        .padding(.horizontal)
    }

    private var recentProjectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Projects")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button("See All") {
                    // Implement "See All" action
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.08))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(appState.projects) { project in
                        ProjectCard(project: project)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)

            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassCard(cornerRadius: 14)
    }
}

struct ProjectCard: View {
    let project: VideoProject

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.6), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 80)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                )

            Text(project.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Text(project.createdAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(14)
    }
}

struct UsageStatsCard: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Free Plan Usage")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Button("Upgrade") {
                    AnalyticsManager.shared.logPaywallView()
                    Task {
                        let success = await appState.subscriptionManager.purchase()
                        // You could add alert logic here too
                    }
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Exports this month")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Text("\(appState.exportCount)/\(appState.maxFreeExports)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }

                ProgressView(value: Double(appState.exportCount), total: Double(appState.maxFreeExports))
                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
            }
        }
        .glassCard()
    }
}

#endif
