// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Endpoint",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(name: "Endpoint", targets: ["Endpoint"]),
    ],
    targets: [
        .target(
            name: "Endpoint",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "EndpointTests",
            dependencies: ["Endpoint"],
            path: "Tests"
        ),
    ]
)
