// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SnapEditAI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SnapEditAI",
            targets: ["SnapEditAI"]
        )
    ],
    targets: [
        .target(
            name: "SnapEditAI",
            path: ".",
            exclude: [
                "Tests",
                "Config.plist.example",
                "README.md",
                "SnapEdit AI - Complete Project Deliverables.md",
                "SnapEdit AI: AI-Powered Video Editor for Short-Form Content.pptx",
                "pasted_content.txt",
                "todo.md",
                "SnapEditAI_Complete_Project.zip"
            ]
        ),
        .testTarget(
            name: "SnapEditAITests",
            dependencies: ["SnapEditAI"],
            path: "Tests"
        )
    ]
)

