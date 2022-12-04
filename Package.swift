// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Endpoint",
    platforms: [.iOS(.v13), .macOS(.v12), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(name: "Endpoint", targets: ["Endpoint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JARMourato/RNP.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "Endpoint", dependencies: ["RNP"], path: "Sources"),
        .testTarget(name: "EndpointTests", dependencies: ["Endpoint"], path: "Tests"),
    ]
)
