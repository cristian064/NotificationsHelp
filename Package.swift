// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationsHelp",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NotificationsHelp",
            targets: ["NotificationsHelp"]),
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "8.0.0")
          )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "NotificationsHelp",
            dependencies: [
                .product(name: "FirebaseMessaging", package: "Firebase"),
                .product(name: "FirebaseAnalytics", package: "Firebase")
            ]),
        .testTarget(
            name: "NotificationsHelpTests",
            dependencies: ["NotificationsHelp"]),
    ]
)
