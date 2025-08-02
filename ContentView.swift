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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("SnapEdit AI")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if !appState.isPremiumUser {
                                Button("Go Pro") {
                                    // Show premium upgrade
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        
                        Text("Shoot. Speak. Sparkle. Go viral in under 60 seconds.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(spacing: 16) {
                        Button(action: {
                            showingVideoPicker = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Create New Video")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            QuickActionCard(
                                icon: "camera.fill",
                                title: "Record",
                                subtitle: "New video"
                            )
                            
                            QuickActionCard(
                                icon: "photo.on.rectangle",
                                title: "Import",
                                subtitle: "From gallery"
                            )
                            
                            QuickActionCard(
                                icon: "wand.and.stars",
                                title: "AI Magic",
                                subtitle: "Auto-edit"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Projects
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Projects")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button("See All") {
                                // Show all projects
                            }
                            .foregroundColor(.purple)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<5) { index in
                                    ProjectCard(index: index)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Usage Stats (for free users)
                    if !appState.isPremiumUser {
                        UsageStatsCard()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingVideoPicker) {
            VideoPickerView()
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
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ProjectCard: View {
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 80)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                )
            
            Text("Video \(index + 1)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Text("2 days ago")
                .font(.caption2)
                .foregroundColor(.gray)
        }
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
                    // Show premium upgrade
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
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

