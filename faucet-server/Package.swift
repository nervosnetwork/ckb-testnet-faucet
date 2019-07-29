// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "faucet-server",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        .package(url: "https://github.com/cezres/ckb-sdk-swift", .revision("0740019586e8283ea7b791c23a8c7b6c9cfa1ea7"))
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "CKB",
            "FluentMySQL",
            ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ],
    swiftLanguageVersions: [.v5]
)
