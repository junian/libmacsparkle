// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let tag = "1.0.9"

let package = Package(
    name: "MacSparkle",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MacSparkle",
            type: .dynamic,
            targets: ["MacSparkle"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", .upToNextMajor(from: "2.9.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MacSparkle",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
            ]
        ),
        .testTarget(
            name: "MacSparkleTests",
            dependencies: ["MacSparkle"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
