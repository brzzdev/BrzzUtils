#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import BrzzTestUtils
import SnapshotTesting
import SwiftUI
import Testing

/// Exercises the AppKit (`NSHostingView`) overload of `assertSnapshotWithLocale`
/// end-to-end on the macOS destination, so the appearance pin and axis-encoded
/// filenames are verified at runtime rather than merely compiled.
///
/// The swatch fills a `Rectangle` with `Color.primary` — black in light, white
/// in dark — so a passing snapshot proves `.environment(\.colorScheme,)` reaches
/// the hosted SwiftUI view. Solid fills keep the reference pixel-exact across
/// machines. The `_light` / `_dark` suffixes come from `snapshotName`, so the two
/// parameterised runs resolve distinct reference files.
@MainActor
struct AppKitSnapshotTests {
	private struct Swatch: View {
		var body: some View {
			Rectangle()
				.fill(Color.primary)
				.frame(width: 64, height: 64)
				.padding()
				.background(Color(white: 0.5))
		}
	}

	@Test(arguments: [ColorScheme.light, .dark])
	func swatch(scheme: ColorScheme) {
		// A slightly relaxed perceptualPrecision absorbs sub-perceptual colour
		// differences between the recording machine and CI while still catching
		// the light-vs-dark flip the test exists to prove.
		Swatch()
			.assertSnapshotWithLocale(perceptualPrecision: 0.98, scheme: scheme)
	}
}
#endif
