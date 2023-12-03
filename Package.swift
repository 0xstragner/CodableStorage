// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodableStorage",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v12),
        .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    products: [
        .library(name: "CodableStorage", targets: ["CodableStorage"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CodableStorage",
            dependencies: [],
            path: "Sources/CodableStorage",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
            ]
        ),
    ]
)
