#if canImport(UIKit)
import SnapshotTesting
import SwiftUI
import UIKit

extension Snapshotting where Value == UIViewController, Format == UIImage {
	/// An image snapshotting strategy that appends the current locale identifier
	/// to the snapshot filename, ensuring each locale gets its own reference image.
	///
	/// This prevents snapshot mismatches when tests run on machines with different
	/// system locales (e.g. local development vs CI).
	public static func imageWithLocale(
		on config: ViewImageConfig,
		perceptualPrecision: Float = 1,
		traits: UITraitCollection = UITraitCollection()
	) -> Snapshotting {
		var strategy: Snapshotting = .image(
			on: config,
			perceptualPrecision: perceptualPrecision,
			traits: traits
		)
		strategy.pathExtension = Locale.current.identifier + ".png"
		return strategy
	}
}

extension View {
	/// Asserts a snapshot of this view using a locale-aware strategy.
	///
	/// Wraps the view in a `UIHostingController` and uses `imageWithLocale`
	/// so each system locale produces its own reference image.
	@MainActor
	public func assertSnapshotWithLocale(
		on config: ViewImageConfig = .iPhone13,
		perceptualPrecision: Float = 1,
		traits: UITraitCollection = UITraitCollection(),
		record: SnapshotTestingConfiguration.Record? = nil,
		fileID: StaticString = #fileID,
		file: StaticString = #filePath,
		testName: String = #function,
		line: UInt = #line,
		column: UInt = #column
	) {
		assertSnapshot(
			of: UIHostingController(rootView: self),
			as: .imageWithLocale(
				on: config,
				perceptualPrecision: perceptualPrecision,
				traits: traits
			),
			record: record,
			fileID: fileID,
			file: file,
			testName: testName,
			line: line,
			column: column
		)
	}
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import SnapshotTesting
import SwiftUI

extension Snapshotting where Value == NSView, Format == NSImage {
	/// An image snapshotting strategy that appends the current locale identifier
	/// to the snapshot filename, ensuring each locale gets its own reference image.
	public static func imageWithLocale(
		perceptualPrecision: Float = 1
	) -> Snapshotting {
		var strategy: Snapshotting = .image(perceptualPrecision: perceptualPrecision)
		strategy.pathExtension = Locale.current.identifier + ".png"
		return strategy
	}
}

extension View {
	/// Asserts a snapshot of this view using a locale-aware strategy.
	///
	/// Wraps the view in an `NSHostingView` and uses `imageWithLocale`
	/// so each system locale produces its own reference image.
	@MainActor
	public func assertSnapshotWithLocale(
		perceptualPrecision: Float = 1,
		record: SnapshotTestingConfiguration.Record? = nil,
		fileID: StaticString = #fileID,
		file: StaticString = #filePath,
		testName: String = #function,
		line: UInt = #line,
		column: UInt = #column
	) {
		let view = NSHostingView(rootView: self)
		assertSnapshot(
			of: view,
			as: .imageWithLocale(perceptualPrecision: perceptualPrecision),
			record: record,
			fileID: fileID,
			file: file,
			testName: testName,
			line: line,
			column: column
		)
	}
}
#endif
