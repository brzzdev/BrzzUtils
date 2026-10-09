#if canImport(UIKit)
import BrzzTestUtils
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

/// Exercises the UIKit (`UIHostingController`) overload of
/// `assertSnapshotWithLocale` at an accessibility size, where UIKit chrome and
/// SwiftUI content take Dynamic Type from different places.
///
/// `.snapshots` gives every test case its own snapshot counter, so each case of a
/// parameterised test resolves the same `.1` reference rather than `.1`, `.2`, …
@MainActor
@Suite(.snapshots)
struct UIKitSnapshotTests {
	/// Records the content-size category of the nearest view controller, the
	/// hosting controller, every time SwiftUI lays the probe out inside a window.
	private final class TraitProbe: UIView {
		var categories: [UIContentSizeCategory] = []

		override func layoutSubviews() {
			super.layoutSubviews()
			guard window != nil else { return }
			let controller = sequence(first: self as UIResponder, next: \.next)
				.lazy
				.compactMap { $0 as? UIViewController }
				.first
			guard let controller else { return }
			categories.append(controller.traitCollection.preferredContentSizeCategory)
		}
	}

	private struct TraitProbeView: UIViewRepresentable {
		let probe: TraitProbe

		func makeUIView(context _: Context) -> TraitProbe {
			probe
		}

		func updateUIView(_: TraitProbe, context _: Context) {}
	}

	@Test
	func contentSizeCategoryTrait() {
		let probe = TraitProbe()
		TraitProbeView(probe: probe)
			.background(Color(white: 0.5))
			.assertSnapshotWithLocale(dynamicTypeSize: .accessibility2)

		#expect(!probe.categories.isEmpty)
		#expect(probe.categories.allSatisfy { $0 == .accessibilityLarge })
	}

	/// The back button is UIKit chrome, so its chevron is sized from the trait
	/// rather than the environment. Repeated because a disagreement between the two
	/// showed up as a chevron that changed size in some runs and not others.
	///
	/// Dark, because the chevron is drawn for a glass platter that the layer render
	/// leaves out: on a light bar it is all but invisible. The relaxed perceptual
	/// precision absorbs anti-aliasing noise between machines; with `precision` at 1,
	/// a white chevron changing size on black still fails.
	@Test(arguments: 1 ... 12)
	func pushedBackButton(run _: Int) {
		NavigationStack(path: .constant([1])) {
			Color(white: 0.5)
				.navigationDestination(for: Int.self) { _ in
					Color(white: 0.5)
						.navigationTitle("Pushed")
						.toolbarTitleDisplayMode(.inline)
				}
		}
		.assertSnapshotWithLocale(
			dynamicTypeSize: .accessibility2,
			perceptualPrecision: 0.98,
			scheme: .dark,
		)
	}
}
#endif
