// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "faucet-server",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver-Vapor.git", from: "1.1.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        .package(url: "https://github.com/ashchan/ckb-sdk-swift", from: "0.25.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "CKB",
            "FluentMySQL",
            "SwiftyBeaverVapor"
            ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ],
    swiftLanguageVersions: [.v5]
)
