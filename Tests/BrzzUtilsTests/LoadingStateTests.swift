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

		// WHEN
		firstLoad.setLoading(true)
		loaded.setLoading(true)

		// THEN
		#expect(firstLoad == .firstLoad)
		#expect(loaded == .refreshing)
	}

	@Test
	func setLoadingFalseMarksLoaded() {
		// GIVEN
		var state = LoadingState.refreshing

		// WHEN
		state.setLoading(false)

		// THEN
		#expect(state == .loaded)
	}

	@Test
	func failStoresTheMessage() {
		// GIVEN
		var state = LoadingState.firstLoad

		// WHEN
		state.fail(message: "Network error")

		// THEN
		#expect(state == .failed(message: "Network error"))
	}
}
