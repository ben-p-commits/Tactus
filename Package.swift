// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Tactus",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Tactus",
            targets: ["Tactus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kolos65/Mockable", from: "0.2.0"),
        .package(url: "https://github.com/Bersaelor/SwiftSplines", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "Tactus",
            dependencies: [
                .product(name: "Mockable", package: "Mockable"),
                .product(name: "SwiftSplines", package: "SwiftSplines")
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
            ]
        ),
    ]
)
