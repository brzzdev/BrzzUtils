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

	/// Transitions to `.refreshing` while loading — or stays on `.firstLoad` when there's no data
	/// yet — and to `.loaded` when finished. It never re-enters `.firstLoad` or `.failed`: to show a
	/// full-screen spinner again after a failure, assign `.firstLoad` explicitly rather than calling
	/// this.
	public mutating func setLoading(_ loading: Bool) {
		if loading {
			guard self != .firstLoad else { return }

			self = .refreshing
		} else {
			self = .loaded
		}
	}

	public mutating func fail(message: String) {
		self = .failed(message: message)
	}
}
