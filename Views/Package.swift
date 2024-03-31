// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Views",
    products: [
        .library(
            name: "Views",
            targets: ["Views"]
        )
    ],
    targets: [
        .target(name: "Views"),
        .testTarget(
            name: "ViewsTests",
            dependencies: ["Views"]
        )
    ]
)
