// swift-tools-version: 6.1

import PackageDescription

private let Tagged = Target.Dependency.product(
	name: "Tagged",
	package: "swift-tagged"
)

private let TCA = Target.Dependency.product(
	name: "ComposableArchitecture",
	package: "swift-composable-architecture"
)

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
			name: "BrzzTestUtils",
			targets: ["BrzzTestUtils"]
		),
		.library(
			name: "BrzzUtils",
			targets: ["BrzzUtils"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/pointfreeco/swift-composable-architecture",
			from: "1.22.1"
		),
		.package(
			url: "https://github.com/pointfreeco/swift-tagged",
			from: "0.10.0"
		),
	],
	targets: [
		.target(
			name: "BrzzTestUtils",
			dependencies: [
				"BrzzUtils",
			]
		),
		.testTarget(
			name: "BrzzTestUtilsTests",
			dependencies: ["BrzzTestUtils"]
		),
		.target(
			name: "BrzzUtils",
			dependencies: [
				Tagged,
				TCA,
			]
		),
		.testTarget(
			name: "BrzzUtilsTests",
			dependencies: ["BrzzUtils"]
		),
	]
)
