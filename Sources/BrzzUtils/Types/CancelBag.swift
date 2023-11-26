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
public final class CancelBag: Sendable {
	/// A thread-safe setter for `Set<AnyCancellable>`.
	fileprivate let cancellables = LockIsolated(Set<AnyCancellable>())
	
	/// Returns count of `AnyCancellable` instances in `CancelBag`.
	public var count: Int {
		cancellables.withValue {
			$0.count
		}
	}
	
	/// `CancellablesBuilder` makes use of `resultBuilder` attribute to transform individual
	/// input `AnyCancellable` instances into a single `Array` of `AnyCancellable` instances.
	@resultBuilder
	public enum CancellablesBuilder {
		public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
			cancellables
		}
	}
	
	// MARK: Lifecycle
	
	public init() {}
	
	// MARK: Public
	
	/// Cancels all `AnyCancellable` instances in `CancelBag`.
	public func cancelAll() {
		cancellables.withValue { cancellables in
			cancellables.forEach { $0.cancel() }
			cancellables = []
		}
	}
	
	/// Stores a new `AnyCancellable` instance.
	///
	/// - Parameter cancellable: A block that returns an `AnyCancellable` instance.
	public func store(@CancellablesBuilder _ cancellable: @Sendable () -> AnyCancellable) {
		store { cancellable() }
	}
	
	/// Stores multiple new `AnyCancellable` instances.
	///
	/// - Parameter newCancellables: A block that returns an `Array` of `AnyCancellable` instances.
	public func store(@CancellablesBuilder _ newCancellables: @Sendable () -> [AnyCancellable]) {
		cancellables.withValue { cancellables in
			cancellables.formUnion(newCancellables())
		}
	}
}

// MARK: - AnyCancellable + Sendable

/// Extension to `AnyCancellable` class to easily store an `AnyCancellable` instance to a `CancelBag`.
extension AnyCancellable: @unchecked Sendable {
	/// Stores `AnyCancellable` instance into a `CancelBag`.
	///
	/// - Parameter cancelBag: `CancelBag` where `AnyCancellable` is going to be stored.
	public func store(in cancelBag: CancelBag) {
		cancelBag.store { self }
	}
}
