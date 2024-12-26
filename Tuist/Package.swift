// swift-tools-version: 6.0
@preconcurrency import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.17.0")
    ]
)

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .framework,
        "Perception": .framework,
        "XCTestDynamicOverlay": .framework
    ]
)
#endif
