// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DI",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "DI", targets: ["DI"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "DI", dependencies: []),
        .testTarget(name: "DITests", dependencies: ["DI"]),
    ]
)
