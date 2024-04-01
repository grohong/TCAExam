// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Views",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Views",
            targets: ["Views"]
        )
    ],
    dependencies: [
        .package(name: "Entities", path: "../Entities")
    ],
    targets: [
        .target(
            name: "Views",
            dependencies: [.product(name: "Entities", package: "Entities")]
        ),
        .testTarget(
            name: "ViewsTests",
            dependencies: ["Views"]
        )
    ]
)
