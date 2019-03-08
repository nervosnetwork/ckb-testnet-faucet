// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "faucet-service",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),        
        .package(url: "https://github.com/cezres/SQLite.swift.git", from: "0.11.6"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "SQLite"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

