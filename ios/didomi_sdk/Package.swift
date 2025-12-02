// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "didomi_sdk",
    platforms: [
        .iOS("10.0")
    ],
    products: [
        .library(name: "didomi-sdk", targets: ["DidomiSwift", "DidomiObjC"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DidomiSwift",
            dependencies: [],
            resources: []
        ),
        .target(
            name: "DidomiObjC",
            dependencies: [],
            resources: [],
            publicHeadersPath: "include"
        )
    ]
)
