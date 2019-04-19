// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "faucet-server",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/cezres/SQLite.swift.git", from: "0.11.6"),
//        .package(url: "https://github.com/nervosnetwork/ckb-sdk-swift", .revision("a649c7fa74027562fc6fa897f66ac22feab25afd")),
        .package(path: "/Users/tekisen/Documents/GitHub/ckb-sdk-swift"),
        .package(url: "https://github.com/norio-nomura/Base32", from: "0.7.0"),
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "SQLite",
            "CKB",
            "Base32"
            ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ],
    swiftLanguageVersions: [.v5]
)
