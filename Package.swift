// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SubscriptionExample",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SubscriptionExample",
            targets: ["SubscriptionExample"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nothing-to-add/swift-custom-extensions", from: "1.0.2")
        // You can add any external dependencies here
        // For example: .package(url: "https://github.com/example/package", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SubscriptionExample",
            dependencies: [
                .product(name: "CustomExtensions", package: "swift-custom-extensions")
            ],
            resources: [
                .process("Resources/en.lproj"),
                .process("Resources/de.lproj")
            ]),
        .testTarget(
            name: "SubscriptionExampleTests",
            dependencies: ["SubscriptionExample"]),
    ]
)
