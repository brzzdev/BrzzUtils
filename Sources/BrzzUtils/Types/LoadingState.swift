import Foundation

public enum LoadingState: Equatable, Sendable {
	case failed(message: String)
	case loaded
	case loadingWithoutContent
	case refreshing

	public var isLoading: Bool {
		switch self {
		case .loadingWithoutContent, .refreshing:
			true

		case .failed, .loaded:
			false
		}
	}

	/// Transitions to `.refreshing` while loading, or stays on `.loadingWithoutContent` when there's
	/// nothing on screen to keep — which includes retrying out of `.failed`. Finishing lands on
	/// `.loaded`, and this never re-enters `.failed`.
	///
	/// Retrying out of `.failed` shows a full-screen spinner rather than an inline one, because
	/// `.failed` should only ever be entered with nothing to show: a refresh that fails over
	/// already-loaded content is expected to leave that content on screen instead of failing.
	public mutating func setLoading(_ loading: Bool) {
		if loading {
			switch self {
			case .failed, .loadingWithoutContent:
				self = .loadingWithoutContent

			case .loaded, .refreshing:
				self = .refreshing
			}
		} else {
			self = .loaded
		}
	}

	public mutating func fail(message: String) {
		self = .failed(message: message)
	}

	/// Enters `.failed` only when there is nothing on screen; otherwise finishes loading and leaves
	/// the already-loaded content up.
	///
	/// This is the invariant `setLoading(_:)` relies on — that `.failed` is only ever entered with
	/// nothing to show — expressed as the call consumers actually make on an error path. When there
	/// is content to keep, `message` is discarded: surfacing it is the caller's job.
	public mutating func fail(message: String, ifEmpty isEmpty: Bool) {
		if isEmpty {
			fail(message: message)
		} else {
			setLoading(false)
		}
	}
}
