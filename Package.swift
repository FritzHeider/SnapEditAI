// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "SnapEditAI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SnapEditAI",
            targets: ["SnapEditAI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.2")
    ],
    targets: [
        .target(
            name: "SnapEditAI",
            dependencies: [],
            path: ".",
            exclude: [
                "Tests",
                ".github",
                "Package.resolved",
                ".DS_Store",
                "todo.md",
                "SnapEdit AI - Complete Project Deliverables.md",
                "Config.plist.example",
                "README.md"
            ]
        ),
        .testTarget(
            name: "SnapEditAITests",
            dependencies: [
                "SnapEditAI",
                .product(name: "ViewInspector", package: "ViewInspector", condition: .when(platforms: [.iOS, .macOS]))
            ],
            path: "Tests"
        )
    ]
)
