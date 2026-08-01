@testable import BrzzUtils
import Testing

struct LoadingStateTests {
	@Test
	func isLoadingIsTrueOnlyWhileFetching() {
		#expect(LoadingState.loadingWithoutContent.isLoading)
		#expect(LoadingState.refreshing.isLoading)
		#expect(!LoadingState.loaded.isLoading)
		#expect(!LoadingState.failed(message: "boom").isLoading)
	}

	@Test
	func setLoadingTrueRefreshesOnlyWhenThereIsContentToKeep() {
		// GIVEN
		var loadingWithoutContent = LoadingState.loadingWithoutContent
		var loaded = LoadingState.loaded
		var refreshing = LoadingState.refreshing
		// A failure is only ever entered with nothing on screen, so retrying has no content either.
		var failed = LoadingState.failed(message: "boom")

		// WHEN
		loadingWithoutContent.setLoading(true)
		loaded.setLoading(true)
		refreshing.setLoading(true)
		failed.setLoading(true)

		// THEN
		#expect(loadingWithoutContent == .loadingWithoutContent)
		#expect(loaded == .refreshing)
		#expect(refreshing == .refreshing)
		#expect(failed == .loadingWithoutContent)
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
		var loadingWithoutContent = LoadingState.loadingWithoutContent
		var loaded = LoadingState.loaded

		// WHEN
		loadingWithoutContent.fail(message: "Network error")
		loaded.fail(message: "Network error")

		// THEN
		#expect(loadingWithoutContent == .failed(message: "Network error"))
		#expect(loaded == .failed(message: "Network error"))
	}

	@Test
	func failIfEmptyOnlyTakesOverTheScreenWhenThereIsNothingToShow() {
		// GIVEN
		var withoutContent = LoadingState.loadingWithoutContent
		var withContent = LoadingState.refreshing

		// WHEN
		withoutContent.fail(message: "Network error", ifEmpty: true)
		withContent.fail(message: "Network error", ifEmpty: false)

		// THEN
		#expect(withoutContent == .failed(message: "Network error"))
		#expect(withContent == .loaded)
	}

	@Test
	func failIfEmptyOverContentKeepsTheNextReloadInline() {
		// GIVEN
		var state = LoadingState.refreshing

		// WHEN
		state.fail(message: "Network error", ifEmpty: false)
		state.setLoading(true)

		// THEN
		// The content is still on screen, so the spinner stays inline rather than taking over.
		#expect(state == .refreshing)
	}
}
