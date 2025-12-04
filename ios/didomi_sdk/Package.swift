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
        .package(url: "https://github.com/didomi/didomi-ios-sdk-spm", from: "2.34.0")
    ],
    targets: [
        .target(
            name: "DidomiSwift",
            dependencies: [
                .product(name: "Didomi", package: "didomi-ios-sdk-spm")
            ],
            path: "Sources/DidomiSwift",
            resources: [],
            linkerSettings: [
                .linkedFramework("Flutter", .when(platforms: [.iOS]))
            ]
        ),
        .target(
            name: "didomi_sdk",
            dependencies: ["DidomiSwift"],
            path: "Sources/DidomiObjC",
            resources: [],
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedFramework("Flutter", .when(platforms: [.iOS]))
            ]
        )
    ]
)
