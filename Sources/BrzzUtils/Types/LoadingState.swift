import Foundation

public enum LoadingState: Equatable, Sendable {
	case failed(message: String)
	case firstLoad
	case loaded
	case refreshing

	public var isLoading: Bool {
		switch self {
		case .firstLoad, .refreshing:
			true

		case .failed, .loaded:
			false
		}
	}

	/// Transitions to `.refreshing` while loading, or to `.firstLoad` when there's nothing on screen
	/// to keep — that's `.firstLoad` itself and `.failed`. Finishing lands on `.loaded`, and this
	/// never re-enters `.failed`.
	///
	/// Retrying out of `.failed` shows a full-screen spinner rather than an inline one, because
	/// `.failed` should only ever be entered with nothing to show: a refresh that fails over
	/// already-loaded content is expected to leave that content on screen instead of failing.
	public mutating func setLoading(_ loading: Bool) {
		if loading {
			switch self {
			case .failed, .firstLoad:
				self = .firstLoad

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
}
