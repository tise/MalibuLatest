// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Malibu",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Malibu",
            targets: ["Malibu"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/tise/When.git", branch: "master"),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMinor(from: "5.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMinor(from: "10.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Malibu",
            dependencies: ["When"],
            path: "./Sources/Malibu"
        ),
        .testTarget(
            name: "malibuTests",
            dependencies: ["Malibu", "Quick", "Nimble"],
            path: "./Tests/MalibuTests",
            resources: [
                .process("JSON"),
            ]
        ),
    ]
)
