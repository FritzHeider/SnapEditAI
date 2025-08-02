import SwiftUI
import PhotosUI

struct VideoPickerView: View {
    @Environment(\.dismiss) private var dismiss
    var onVideoSelected: ((URL) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Import Video")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    ImportOptionCard(
                        icon: "camera.fill",
                        title: "Record New",
                        subtitle: "Capture video with camera",
                        color: .red
                    ) {
                        // Open camera
                        dismiss()
                    }
                    
                    ImportOptionCard(
                        icon: "photo.on.rectangle",
                        title: "Photo Library",
                        subtitle: "Choose from your videos",
                        color: .blue
                    ) {
                        // Open photo library
                        if let url = URL(string: "sample_video.mp4") {
                            onVideoSelected?(url)
                        }
                        dismiss()
                    }
                    
                    ImportOptionCard(
                        icon: "icloud.and.arrow.down",
                        title: "iCloud Drive",
                        subtitle: "Import from cloud storage",
                        color: .green
                    ) {
                        // Open iCloud picker
                        dismiss()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct ImportOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct TemplatesView: View {
    @StateObject private var viewModel = TemplatesViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(TemplateCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.05))

                // Templates Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.filteredTemplates) { template in
                            TemplateCard(template: template)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

enum TemplateCategory: String, CaseIterable {
    case trending = "Trending"
    case educational = "Educational"
    case business = "Business"
    case lifestyle = "Lifestyle"
    
    var icon: String {
        switch self {
        case .trending: return "flame.fill"
        case .educational: return "graduationcap.fill"
        case .business: return "briefcase.fill"
        case .lifestyle: return "heart.fill"
        }
    }
}

struct Template: Identifiable {
    let id = UUID()
    let name: String
    let category: TemplateCategory
    let thumbnail: String
}

struct CategoryButton: View {
    let category: TemplateCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.purple : Color.gray.opacity(0.2))
            )
        }
    }
}

struct TemplateCard: View {
    let template: Template
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(9/16, contentMode: .fit)
                
                Image(systemName: template.thumbnail)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(template.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            // Use template
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.purple)
                            )
                        
                        VStack(spacing: 4) {
                            Text("Creator")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(appState.isPremiumUser ? "Pro Member" : "Free Plan")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Subscription Status
                    if !appState.isPremiumUser {
                        VStack(spacing: 12) {
                            Text("Upgrade to Pro")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Unlock unlimited exports, premium templates, and AI features")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Button("Upgrade Now") {
                                // Show upgrade options
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        ProfileMenuItem(
                            icon: "video.fill",
                            title: "My Projects",
                            subtitle: "View all your videos"
                        )
                        
                        ProfileMenuItem(
                            icon: "square.and.arrow.up",
                            title: "Export History",
                            subtitle: "Track your exports"
                        )
                        
                        ProfileMenuItem(
                            icon: "gear",
                            title: "Settings",
                            subtitle: "App preferences"
                        ) {
                            showingSettings = true
                        }
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            subtitle: "Get assistance"
                        )
                        
                        ProfileMenuItem(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback"
                        )
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.purple)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var autoSave = true
    @State private var highQuality = false
    @State private var notifications = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Export Settings") {
                    Toggle("Auto-save to Photos", isOn: $autoSave)
                    Toggle("High Quality Export", isOn: $highQuality)
                }
                
                Section("Notifications") {
                    Toggle("Export Complete", isOn: $notifications)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ExportOptionsView: View {
    let project: VideoProject
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @State private var selectedQuality: ExportQuality = .high
    @State private var selectedPlatform: Platform = .tiktok
    @State private var isExporting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Export Video")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    // Platform Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Platform")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            ForEach(Platform.allCases, id: \.self) { platform in
                                PlatformButton(
                                    platform: platform,
                                    isSelected: selectedPlatform == platform
                                ) {
                                    selectedPlatform = platform
                                }
                            }
                        }
                    }
                    
                    // Quality Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quality")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 8) {
                            ForEach(ExportQuality.allCases, id: \.self) { quality in
                                QualityOption(
                                    quality: quality,
                                    isSelected: selectedQuality == quality,
                                    isPremium: quality == .ultra && !appState.isPremiumUser
                                ) {
                                    if quality == .ultra && !appState.isPremiumUser {
                                        AnalyticsManager.shared.logPaywallView()
                                        // Show upgrade prompt
                                    } else {
                                        selectedQuality = quality
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Export Button
                Button(action: {
                    exportVideo()
                }) {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(isExporting ? "Exporting..." : "Export Video")
                            .font(.headline)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isExporting)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func exportVideo() {
        isExporting = true
        
        // Simulate export process
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isExporting = false
            appState.incrementExportCount()
            AnalyticsManager.shared.logExport()
            dismiss()
        }
    }
}

enum Platform: String, CaseIterable {
    case tiktok = "TikTok"
    case instagram = "Instagram"
    case youtube = "YouTube"
    
    var icon: String {
        switch self {
        case .tiktok: return "music.note"
        case .instagram: return "camera"
        case .youtube: return "play.rectangle"
        }
    }
}

enum ExportQuality: String, CaseIterable {
    case standard = "Standard (720p)"
    case high = "High (1080p)"
    case ultra = "Ultra (4K)"
    
    var description: String {
        switch self {
        case .standard: return "Good for quick sharing"
        case .high: return "Best for most platforms"
        case .ultra: return "Maximum quality (Pro only)"
        }
    }
}

struct PlatformButton: View {
    let platform: Platform
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: platform.icon)
                    .font(.title2)
                
                Text(platform.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.purple : Color.gray.opacity(0.2))
            )
        }
    }
}

struct QualityOption: View {
    let quality: ExportQuality
    let isSelected: Bool
    let isPremium: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(quality.rawValue)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if isPremium {
                            Text("PRO")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.purple.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(quality.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.purple)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
            )
        }
        .disabled(isPremium)
        .opacity(isPremium ? 0.6 : 1.0)
    }
}

#Preview {
    VideoPickerView()
}

