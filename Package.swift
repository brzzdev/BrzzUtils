// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "BrzzUtils",
	platforms: [
		.iOS(.v18),
		.macOS(.v15),
		.tvOS(.v18),
		.watchOS(.v11),
	],
	products: [
		.library(
			name: "BrzzUtils",
			targets: ["BrzzUtils"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/pointfreeco/swift-composable-architecture",
			from: "1.0.0"
		),
	],
	targets: [
		.target(
			name: "BrzzUtils",
			dependencies: [
				.product(
					name: "ComposableArchitecture",
					package: "swift-composable-architecture"
				),
			]
		),
		.testTarget(
			name: "BrzzUtilsTests",
			dependencies: ["BrzzUtils"]
		),
	]
)
