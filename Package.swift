// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "BrzzUtils",
	platforms: [
		.iOS(.v14),
		.macOS(.v11),
		.tvOS(.v14),
		.watchOS(.v7),
	],
	products: [
		.library(
			name: "BrzzUtils",
			targets: ["BrzzUtils"]),
	],
	dependencies: [
		.package(
			url: "https://github.com/evgenyneu/keychain-swift",
			from: "24.0.0"
		),
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
				.product(
					name: "KeychainSwift",
					package: "keychain-swift"
				),
			]
		),
		.testTarget(
			name: "BrzzUtilsTests",
			dependencies: ["BrzzUtils"]
		),
	]
)
