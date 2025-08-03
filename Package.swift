// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SnapEditAI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SnapEditAI", targets: ["SnapEditAI"])
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.11")
    ],
    targets: [
        .target(
            name: "SnapEditAI",
            path: ".",
            exclude: [
                "README.md",
                "todo.md",
                "pasted_content.txt",
                "SnapEditAI_Complete_Project.zip",
                "SnapEdit AI - Complete Project Deliverables.md",
                "SnapEdit AI: AI-Powered Video Editor for Short-Form Content.pptx",
                "Tests",
                ".git",
                ".DS_Store",
                "Config.plist.example"
            ],
            sources: [
                "ContentView.swift",
                "EditorView.swift",
                "OnboardingView.swift",
                "SnapEditAIApp.swift",
                "SupportingViews.swift",
                "EditorViewModel.swift",
                "TemplatesViewModel.swift",
                "ConfigManager.swift"
            ]
        ),
        .testTarget(
            name: "SnapEditAITests",
            dependencies: [
                "SnapEditAI",
                .product(name: "ViewInspector", package: "ViewInspector")
            ],
            path: "Tests"
        )
    ]
)
