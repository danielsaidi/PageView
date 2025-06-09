// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PageView",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "PageView",
            targets: ["PageView"]
        )
    ],
    targets: [
        .target(
            name: "PageView"
        ),
        .testTarget(
            name: "PageViewTests",
            dependencies: ["PageView"]
        )
    ]
)
