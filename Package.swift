// swift-tools-version: 5.7

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
