// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Entities",
    products: [
        .library(
            name: "Entities",
            targets: ["Entities"]
        )
    ],
    targets: [
        .target(
            name: "Entities",
            resources: [.process("Resources/Tracks")]
        ),
        .testTarget(
            name: "EntitiesTests",
            dependencies: ["Entities"]
        ),
    ]
)
