// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SnapEditAI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SnapEditAI",
            targets: ["SnapEditAI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.5")
    ],
    targets: [
        .target(
            name: "SnapEditAI",
            path: "Sources/SnapEditAI"
        ),
        .testTarget(
            name: "SnapEditAITests",
            dependencies: ["SnapEditAI", "ViewInspector"],
            path: "Tests/SnapEditAITests"
        ),
        .testTarget(
            name: "SnapEditAIUITests",
            dependencies: ["SnapEditAI", "ViewInspector"],
            path: "Tests/SnapEditAIUITests"
        )
    ]
)
