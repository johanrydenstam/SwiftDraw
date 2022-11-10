// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "SwiftDraw",
	  platforms: [
        .iOS(.v10), .macOS(.v10_12), .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "swiftdraw", targets: ["CommandLine"]),
		.library(
            name: "SwiftDraw",
            targets: ["SwiftDraw"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftDraw",
            dependencies: [],
			path: "SwiftDraw"
		),
        .executableTarget(
            name: "CommandLine",
            dependencies: ["SwiftDraw"],
            path: "CommandLine"
		),
        .testTarget(
            name: "SwiftDrawTests",
            dependencies: ["SwiftDraw"],
            path: "SwiftDrawTests",
            resources: [
                .process("Samples")
            ]
		)
    ]
)
