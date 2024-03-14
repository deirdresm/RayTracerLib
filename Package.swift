// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RayTracerLib",
	platforms: [
		.macOS(.v14),
		.iOS(.v16),
		.visionOS(.v1)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RayTracerLib",
            targets: ["RayTracerLib"]),
		.executable(
			name: "RayTracerLibCLI",
			targets: ["RayTracerLibCLI"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RayTracerLib"),
		.executableTarget(
			name: "RayTracerLibCLI",
			dependencies: ["RayTracerLib"]),
        .testTarget(
            name: "RayTracerLibTests",
            dependencies: ["RayTracerLib"]),
    ]
)

// xcodebuild test -scheme RayTracerLib -sdk iphoneos17.2 -destination "OS=17.2,name=iPhone 15 Pro"
// xcodebuild test -scheme RayTracerLib -sdk macosx14.2
