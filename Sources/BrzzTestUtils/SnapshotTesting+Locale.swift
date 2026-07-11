#if canImport(UIKit)
public import SnapshotTesting
public import SwiftUI
import UIKit

extension Snapshotting where Value == UIViewController, Format == UIImage {
	/// An image snapshotting strategy that appends a fixed locale identifier to
	/// the snapshot filename so references are reproducible across machines.
	///
	/// The reference is keyed to `locale` (not the ambient system locale), so a
	/// UK dev machine and a US-region CI runner resolve the same file. Pair this
	/// with `.dependency(\.locale, locale)` and `.dependency(\.timeZone, …)` in
	/// the test suite so the rendered content is deterministic too.
	public static func imageWithLocale(
		on config: ViewImageConfig,
		locale: Locale = Locale(identifier: "en_GB"),
		perceptualPrecision: Float = 1,
		traits: UITraitCollection = UITraitCollection(),
	) -> Snapshotting {
		var strategy: Snapshotting = .image(
			on: config,
			perceptualPrecision: perceptualPrecision,
			traits: traits,
		)
		strategy.pathExtension = locale.identifier + ".png"
		return strategy
	}
}

extension View {
	/// Asserts a snapshot of this view using a locale-aware strategy.
	///
	/// Wraps the view in a `UIHostingController` and uses `imageWithLocale`
	/// so the reference filename is keyed to a fixed locale (default `en_GB`).
	@MainActor
	public func assertSnapshotWithLocale(
		on config: ViewImageConfig = .iPhone13,
		locale: Locale = Locale(identifier: "en_GB"),
		perceptualPrecision: Float = 1,
		traits: UITraitCollection = UITraitCollection(),
		record: SnapshotTestingConfiguration.Record? = nil,
		fileID: StaticString = #fileID,
		file: StaticString = #filePath,
		testName: String = #function,
		line: UInt = #line,
		column: UInt = #column,
	) {
		assertSnapshot(
			of: UIHostingController(rootView: self),
			as: .imageWithLocale(
				on: config,
				locale: locale,
				perceptualPrecision: perceptualPrecision,
				traits: traits,
			),
			record: record,
			fileID: fileID,
			file: file,
			testName: testName,
			line: line,
			column: column,
		)
	}
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public import SnapshotTesting
public import SwiftUI

extension Snapshotting where Value == NSView, Format == NSImage {
	/// An image snapshotting strategy that appends a fixed locale identifier to
	/// the snapshot filename so references are reproducible across machines.
	public static func imageWithLocale(
		locale: Locale = Locale(identifier: "en_GB"),
		perceptualPrecision: Float = 1,
	) -> Snapshotting {
		var strategy: Snapshotting = .image(perceptualPrecision: perceptualPrecision)
		strategy.pathExtension = locale.identifier + ".png"
		return strategy
	}
}

extension View {
	/// Asserts a snapshot of this view using a locale-aware strategy.
	///
	/// Wraps the view in an `NSHostingView` and uses `imageWithLocale`
	/// so the reference filename is keyed to a fixed locale (default `en_GB`).
	@MainActor
	public func assertSnapshotWithLocale(
		locale: Locale = Locale(identifier: "en_GB"),
		perceptualPrecision: Float = 1,
		record: SnapshotTestingConfiguration.Record? = nil,
		fileID: StaticString = #fileID,
		file: StaticString = #filePath,
		testName: String = #function,
		line: UInt = #line,
		column: UInt = #column,
	) {
		let view = NSHostingView(rootView: self)
		assertSnapshot(
			of: view,
			as: .imageWithLocale(locale: locale, perceptualPrecision: perceptualPrecision),
			record: record,
			fileID: fileID,
			file: file,
			testName: testName,
			line: line,
			column: column,
		)
	}
}
#endif
