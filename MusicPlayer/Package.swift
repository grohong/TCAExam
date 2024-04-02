// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MusicPlayer",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "MusicPlayer",
            targets: ["MusicPlayer"]
        )
    ],
    dependencies: [
        .package(name: "Entities", path: "../Entities"),
        .package(name: "Shared", path: "../Shared")
    ],
    targets: [
        .target(
            name: "MusicPlayer",
            dependencies: [
                .product(name: "Entities", package: "Entities"),
                .product(name: "Shared", package: "Shared")
            ]
        ),
        .testTarget(
            name: "MusicPlayerTests",
            dependencies: ["MusicPlayer"]
        )
    ]
)
