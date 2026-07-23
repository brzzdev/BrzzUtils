#if canImport(UIKit) || canImport(AppKit)
public import SwiftUI

/// Builds the reference filename for a snapshot from the axes it was rendered at.
///
/// `testName` arrives as `#function`, which reads `foo()` for a plain test and
/// `foo(scheme:)` for a parameterised one; truncating at the first `(` makes both
/// yield the same base, so a suite can be parameterised without renaming its
/// references.
///
/// The colour scheme is always encoded, so no filename implicitly means light.
/// Every other axis is encoded only when it differs from its default, so adding a
/// future axis renames nothing that does not use it.
///
/// Tokens come from the enum case names (`light`, `accessibility2`), which is why
/// changing an axis' default is a corpus-wide rename.
func snapshotName(
	testName: String,
	scheme: ColorScheme,
	dynamicTypeSize: DynamicTypeSize,
) -> String {
	var name = String(testName.prefix { $0 != "(" })
	name += "_\(scheme)"
	if dynamicTypeSize != .large {
		name += "_\(dynamicTypeSize)"
	}
	return name
}
#endif

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
	) -> Snapshotting {
		var strategy: Snapshotting = .image(
			on: config,
			perceptualPrecision: perceptualPrecision,
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
	///
	/// Appearance and Dynamic Type are applied through the SwiftUI environment and
	/// are *always* applied, so a snapshot never renders against whatever ambient
	/// state the shared snapshot window happens to hold. Deliberately there is no
	/// `traits:` escape hatch: `UITraitCollection(userInterfaceStyle:)` sets
	/// `overrideUserInterfaceStyle` on that shared window, which outlives the
	/// assertion and leaks into later suites' references.
	///
	/// The reference filename encodes the axes — see `snapshotName(testName:…)`.
	@MainActor
	public func assertSnapshotWithLocale(
		on config: ViewImageConfig = .iPhone13,
		dynamicTypeSize: DynamicTypeSize = .large,
		locale: Locale = Locale(identifier: "en_GB"),
		perceptualPrecision: Float = 1,
		scheme: ColorScheme = .light,
		record: SnapshotTestingConfiguration.Record? = nil,
		fileID: StaticString = #fileID,
		file: StaticString = #filePath,
		testName: String = #function,
		line: UInt = #line,
		column: UInt = #column,
	) {
		let rootView =
			environment(\.colorScheme, scheme)
				.dynamicTypeSize(dynamicTypeSize)

		assertSnapshot(
			of: UIHostingController(rootView: rootView),
			as: .imageWithLocale(
				on: config,
				locale: locale,
				perceptualPrecision: perceptualPrecision,
			),
			record: record,
			fileID: fileID,
			file: file,
			testName: snapshotName(
				testName: testName,
				scheme: scheme,
				dynamicTypeSize: dynamicTypeSize,
			),
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

extension Snapshotting where Value == NSImage, Format == NSImage {
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

/// Rasterises `view` into an image at a fixed scale so the reference is
/// reproducible on any machine.
///
/// `NSView`'s own display caching draws at the backing scale of whatever screen
/// the process happens to see — 2× on a Retina dev Mac, 1× on a headless CI
/// runner — so snapshotting the view directly bakes the recording machine's
/// scale into the reference and mismatches everywhere else. Drawing into a
/// bitmap whose pixel dimensions we fix (points × `scale`) pins the output; the
/// bitmap's own colour space keeps the pixels deterministic too, rather than
/// following the display's.
@MainActor
private func fixedScaleImage(of view: NSView, scale: CGFloat) -> NSImage {
	let size = view.bounds.size
	let rep = NSBitmapImageRep(
		bitmapDataPlanes: nil,
		pixelsWide: Int((size.width * scale).rounded()),
		pixelsHigh: Int((size.height * scale).rounded()),
		bitsPerSample: 8,
		samplesPerPixel: 4,
		hasAlpha: true,
		isPlanar: false,
		colorSpaceName: .deviceRGB,
		bytesPerRow: 0,
		bitsPerPixel: 0,
	)!
	rep.size = size
	view.cacheDisplay(in: view.bounds, to: rep)
	let image = NSImage(size: size)
	image.addRepresentation(rep)
	return image
}

extension View {
	/// Asserts a snapshot of this view using a locale-aware strategy.
	///
	/// Wraps the view in an `NSHostingView`, rasterises it at a fixed scale, and
	/// uses `imageWithLocale` so the reference filename is keyed to a fixed locale
	/// (default `en_GB`).
	///
	/// Appearance and Dynamic Type are applied through the SwiftUI environment and
	/// are always applied, matching the UIKit overload so both platforms key their
	/// references the same way.
	@MainActor
	public func assertSnapshotWithLocale(
		dynamicTypeSize: DynamicTypeSize = .large,
		locale: Locale = Locale(identifier: "en_GB"),
		perceptualPrecision: Float = 1,
		scheme: ColorScheme = .light,
		record: SnapshotTestingConfiguration.Record? = nil,
		fileID: StaticString = #fileID,
		file: StaticString = #filePath,
		testName: String = #function,
		line: UInt = #line,
		column: UInt = #column,
	) {
		let rootView =
			environment(\.colorScheme, scheme)
				.dynamicTypeSize(dynamicTypeSize)

		// NSHostingView starts life at a zero frame — unlike UIHostingController on
		// the UIKit path, nothing lays it out before snapshotting. Size it to the
		// SwiftUI content's fitting size, then rasterise at a fixed scale so the
		// reference is identical on a Retina dev Mac and a 1× CI runner.
		let hostingView = NSHostingView(rootView: rootView)
		hostingView.frame.size = hostingView.fittingSize
		let image = fixedScaleImage(of: hostingView, scale: 2)

		assertSnapshot(
			of: image,
			as: .imageWithLocale(locale: locale, perceptualPrecision: perceptualPrecision),
			record: record,
			fileID: fileID,
			file: file,
			testName: snapshotName(
				testName: testName,
				scheme: scheme,
				dynamicTypeSize: dynamicTypeSize,
			),
			line: line,
			column: column,
		)
	}
}
#endif
