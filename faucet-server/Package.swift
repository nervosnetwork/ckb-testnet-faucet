// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "faucet-server",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),        
        .package(url: "https://github.com/cezres/SQLite.swift.git", from: "0.11.6"),
        .package(url: "https://github.com/nervosnetwork/ckb-sdk-swift", from: "0.7.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "SQLite",
            "CKB"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
