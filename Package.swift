// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftConcurrencyWorkshop",
    platforms: [.macOS(.v15), .iOS(.v18)],
    targets: [
        .testTarget(
            name: "SwiftConcurrencyWorkshop",
        ),
    ]
)
