// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "PageView",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
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
