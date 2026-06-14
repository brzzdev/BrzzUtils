@testable import BrzzUtils
import Testing

struct LoadingStateTests {
	@Test
	func isLoadingIsTrueOnlyWhileFetching() {
		#expect(LoadingState.firstLoad.isLoading)
		#expect(LoadingState.refreshing.isLoading)
		#expect(!LoadingState.loaded.isLoading)
		#expect(!LoadingState.failed(message: "boom").isLoading)
	}

	@Test
	func setLoadingTrueKeepsFirstLoadButOtherwiseRefreshes() {
		// GIVEN
		var firstLoad = LoadingState.firstLoad
		var loaded = LoadingState.loaded
		// Recovering from a failure never returns to `.firstLoad`.
		var failed = LoadingState.failed(message: "boom")

		// WHEN
		firstLoad.setLoading(true)
		loaded.setLoading(true)
		failed.setLoading(true)

		// THEN
		#expect(firstLoad == .firstLoad)
		#expect(loaded == .refreshing)
		#expect(failed == .refreshing)
	}

	@Test
	func setLoadingFalseMarksLoaded() {
		// GIVEN
		var refreshing = LoadingState.refreshing
		var failed = LoadingState.failed(message: "boom")

		// WHEN
		refreshing.setLoading(false)
		failed.setLoading(false)

		// THEN
		#expect(refreshing == .loaded)
		#expect(failed == .loaded)
	}

	@Test
	func failStoresTheMessageFromAnyState() {
		// GIVEN
		var firstLoad = LoadingState.firstLoad
		var loaded = LoadingState.loaded

		// WHEN
		firstLoad.fail(message: "Network error")
		loaded.fail(message: "Network error")

		// THEN
		#expect(firstLoad == .failed(message: "Network error"))
		#expect(loaded == .failed(message: "Network error"))
	}
}
