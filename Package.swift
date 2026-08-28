// swift-tools-version: 6.3

import PackageDescription

private let ConcurrencyExtras = Target.Dependency.product(
	name: "ConcurrencyExtras",
	package: "swift-concurrency-extras",
)

private let Dependencies = Target.Dependency.product(
	name: "Dependencies",
	package: "swift-dependencies",
)

private let DependenciesMacros = Target.Dependency.product(
	name: "DependenciesMacros",
	package: "swift-dependencies",
)

private let IdentifiedCollections = Target.Dependency.product(
	name: "IdentifiedCollections",
	package: "swift-identified-collections",
)

private let IssueReporting = Target.Dependency.product(
	name: "IssueReporting",
	package: "xctest-dynamic-overlay",
)

private let SnapshotTesting = Target.Dependency.product(
	name: "SnapshotTesting",
	package: "swift-snapshot-testing",
)

private let Tagged = Target.Dependency.product(
	name: "Tagged",
	package: "swift-tagged",
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
			url: "https://github.com/pointfreeco/swift-concurrency-extras",
			from: "1.4.1",
		),
		.package(
			url: "https://github.com/pointfreeco/swift-dependencies",
			from: "1.17.0",
		),
		.package(
			url: "https://github.com/pointfreeco/swift-identified-collections",
			from: "1.1.1",
		),
		.package(
			url: "https://github.com/pointfreeco/swift-snapshot-testing",
			from: "1.19.4",
		),
		.package(
			url: "https://github.com/pointfreeco/swift-tagged",
			from: "0.10.0",
		),
		.package(
			// `swift-dependencies` 1.16.0 still uses this identity. Depending on
			// `swift-issue-reporting` directly would load both packages and give the
			// graph duplicate `IssueReporting` targets until the 1.12 shim is tagged.
			url: "https://github.com/pointfreeco/xctest-dynamic-overlay",
			from: "1.13.1",
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
				ConcurrencyExtras,
				Dependencies,
				DependenciesMacros,
				IdentifiedCollections,
				IssueReporting,
				Tagged,
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
