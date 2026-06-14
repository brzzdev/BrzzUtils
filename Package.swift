// swift-tools-version: 6.3

import PackageDescription

private let SnapshotTesting = Target.Dependency.product(
	name: "SnapshotTesting",
	package: "swift-snapshot-testing",
)

private let Tagged = Target.Dependency.product(
	name: "Tagged",
	package: "swift-tagged",
)

private let TCA = Target.Dependency.product(
	name: "ComposableArchitecture",
	package: "swift-composable-architecture",
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
			targets: ["BrzzTestUtils"],
		),
		.library(
			name: "BrzzUtils",
			targets: ["BrzzUtils"],
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/pointfreeco/swift-composable-architecture",
			from: "1.26.0",
		),
		.package(
			url: "https://github.com/pointfreeco/swift-snapshot-testing",
			from: "1.19.2",
		),
		.package(
			url: "https://github.com/pointfreeco/swift-tagged",
			from: "0.10.0",
		),
	],
	targets: [
		.target(
			name: "BrzzTestUtils",
			dependencies: [
				"BrzzUtils",
				SnapshotTesting,
			],
		),
		.testTarget(
			name: "BrzzTestUtilsTests",
			dependencies: ["BrzzTestUtils"],
		),
		.target(
			name: "BrzzUtils",
			dependencies: [
				Tagged,
				TCA,
			],
		),
		.testTarget(
			name: "BrzzUtilsTests",
			dependencies: ["BrzzUtils"],
		),
	],
)

for target in package.targets {
	target.swiftSettings = target.swiftSettings ?? []
	target.swiftSettings?.append(contentsOf: [
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("ImmutableWeakCaptures"),
		.enableUpcomingFeature("InferIsolatedConformances"),
		.enableUpcomingFeature("InternalImportsByDefault"),
		.enableUpcomingFeature("MemberImportVisibility"),
		.enableUpcomingFeature("NonisolatedNonsendingByDefault"),
	])
	#if compiler(>=6.4)
	target.swiftSettings?.append(contentsOf: [
		.treatAllWarnings(as: .error),
	])
	#endif
}
