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
