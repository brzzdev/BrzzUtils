import Combine
import ConcurrencyExtras
import Foundation

/// `CancelBag` is a utility class that stores multiple `AnyCancellable` instances and provides functionalities
/// to handle their lifecycle collectively.
/// The `AnyCancellable` instances are stored in a thread-safe manner.
///
/// This class can be used to keep track of multiple `AnyCancellable` instances,
/// store new `AnyCancellable` instances, and cancel all stored `AnyCancellable` instances.
public struct CancelBag: Sendable {
	private let cancellables = LockIsolated<Set<AnyCancellable>>([])
	private let onlyOne: Bool

	/// Count of `AnyCancellable` held in `CancelBag`.
	public var count: Int {
		cancellables.withValue {
			$0.count
		}
	}

	/// If `CancelBag` is empty.
	public var isEmpty: Bool {
		cancellables.withValue {
			$0.isEmpty
		}
	}

	public init(onlyOne: Bool = false) {
		self.onlyOne = onlyOne
	}

	/// Cancels all `AnyCancellable` instances in `CancelBag`.
	public func cancelAll() {
		cancellables.withValue {
			cancelAll(&$0)
		}
	}

	fileprivate func store(_ cancellable: AnyCancellable) {
		nonisolated(unsafe) let cancellable = cancellable
		cancellables.withValue {
			if onlyOne {
				cancelAll(&$0)
			}

			$0.insert(cancellable)
		}
	}

	private func cancelAll(_ set: inout Set<AnyCancellable>) {
		set.forEach { $0.cancel() }
		set = []
	}
}

/// Extension to `AnyCancellable` class to easily store an `AnyCancellable` instance to a `CancelBag`.
extension AnyCancellable {
	/// Stores `AnyCancellable` instance into a `CancelBag`.
	///
	/// - Parameter cancelBag: `CancelBag` where `AnyCancellable` is going to be stored.
	public func store(in cancelBag: CancelBag) {
		cancelBag.store(self)
	}
}
