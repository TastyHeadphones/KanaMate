// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KanaMate",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "KanaMate",
            targets: ["KanaMate"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KanaMate",
            dependencies: []
        ),
        .testTarget(
            name: "KanaMateTests",
            dependencies: ["KanaMate"]
        ),
    ]
)