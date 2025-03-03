// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "BrzzUtils",
	platforms: [
		.iOS(.v16),
		.macOS(.v13),
		.tvOS(.v17),
		.watchOS(.v10),
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
			from: "1.17.1"
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
