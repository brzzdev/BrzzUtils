import Combine
import ConcurrencyExtras
import Foundation

// MARK: - CancelBag

/// `CancelBag` is a utility class that stores multiple `AnyCancellable` instances and provides functionalities
/// to handle their lifecycle collectively.
/// The `AnyCancellable` instances are stored in a thread-safe manner.
///
/// This class can be used to keep track of multiple `AnyCancellable` instances,
/// store new `AnyCancellable` instances, and cancel all stored `AnyCancellable` instances.
public final class CancelBag: @unchecked Sendable {
	private var cancellables = Set<AnyCancellable>()
	private let lock = NSLock()

	/// Count of `AnyCancellable` held in `CancelBag`.
	public var count: Int {
		lock.withLock {
			cancellables.count
		}
	}

	/// If `CancelBag` is empty.
	public var isEmpty: Bool {
		lock.withLock {
			cancellables.isEmpty
		}
	}

	public init() {}

	// MARK: Public

	/// Cancels all `AnyCancellable` instances in `CancelBag`.
	public func cancelAll() {
		lock.withLock {
			cancellables.forEach { $0.cancel() }
			cancellables = []
		}
	}

	fileprivate func store(_ cancellable: AnyCancellable) {
		lock.withLock {
			_ = cancellables.insert(cancellable)
		}
	}
}

// MARK: - AnyCancellable + Sendable

/// Extension to `AnyCancellable` class to easily store an `AnyCancellable` instance to a `CancelBag`.
extension AnyCancellable {
	/// Stores `AnyCancellable` instance into a `CancelBag`.
	///
	/// - Parameter cancelBag: `CancelBag` where `AnyCancellable` is going to be stored.
	public func store(in cancelBag: CancelBag) {
		cancelBag.store(self)
	}
}
