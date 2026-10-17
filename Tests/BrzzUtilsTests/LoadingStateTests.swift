@testable import BrzzUtils
import Testing

struct LoadingStateTests {
	@Test
	func `is loading is true only while fetching`() {
		#expect(LoadingState.loadingWithoutContent.isLoading)
		#expect(LoadingState.refreshing.isLoading)
		#expect(!LoadingState.loaded.isLoading)
		#expect(!LoadingState.failed(message: "boom").isLoading)
	}

	@Test
	func `set loading true refreshes only when there is content to keep`() {
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
	func `set loading false marks loaded`() {
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
	func `fail stores the message from any state`() {
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
	func `fail if empty only takes over the screen when there is nothing to show`() {
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
	func `fail if empty over content keeps the next reload inline`() {
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
