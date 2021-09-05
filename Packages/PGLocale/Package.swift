// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PGLocale",
    defaultLocalization: "en",
    products: [
        .library(
            name: "PGLocale",
            targets: ["PGLocale"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PGLocale",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "PGLocaleTests",
            dependencies: ["PGLocale"]),
    ]
)
