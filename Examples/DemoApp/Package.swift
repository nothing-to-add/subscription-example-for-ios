// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DemoApp",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "DemoApp",
            targets: ["DemoApp"])
    ],
    dependencies: [
        // Reference the parent package
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "DemoApp",
            dependencies: [
                .product(name: "SubscriptionExample", package: "../..")
            ],
            path: ".")
    ]
)
