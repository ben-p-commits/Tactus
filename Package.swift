// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Tactus",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "Tactus",
            targets: ["Tactus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kolos65/Mockable", from: "0.2.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "Tactus",
            dependencies: [
                .product(name: "Mockable", package: "Mockable"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            swiftSettings: [
                .define("MOCKING", .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "TactusTests",
            dependencies: [
                "Tactus",
                .product(name: "Mockable", package: "Mockable"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ]
        ),
    ]
)
