// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "didomi_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "didomi-sdk", targets: ["didomi_sdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/didomi/didomi-ios-sdk-spm", from: "2.42.0")
    ],
    targets: [
        .target(
            name: "DidomiSwift",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "Didomi", package: "didomi-ios-sdk-spm")
            ],
            path: "Sources/DidomiSwift",
            resources: []
        ),
        .target(
            name: "didomi_sdk",
            dependencies: [
                "DidomiSwift",
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/DidomiObjC",
            resources: [],
            publicHeadersPath: "include"
        )
    ]
)
