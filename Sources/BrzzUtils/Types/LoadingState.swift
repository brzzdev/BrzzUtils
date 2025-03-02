import Foundation

public enum LoadingState: Equatable, Sendable {
	case firstLoad
	case loaded
	case refreshing

	public var isLoading: Bool {
		switch self {
		case .firstLoad, .refreshing:
			return true
		case .loaded:
			return false
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
}
