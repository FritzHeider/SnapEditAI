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
                ".DS_Store"
            ],
            sources: [
                "ContentView.swift",
                "EditorView.swift",
                "OnboardingView.swift",
                "SnapEditAIApp.swift",
                "SupportingViews.swift",
                "EditorViewModel.swift",
                "TemplatesViewModel.swift",
                "Persistence/PersistenceManager.swift"
            ]
        ),
        .testTarget(
            name: "SnapEditAITests",
            dependencies: ["SnapEditAI"],
            path: "Tests"
        )
    ]
)
