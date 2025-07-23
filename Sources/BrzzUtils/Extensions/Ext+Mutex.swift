import Foundation
import Synchronization

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Mutex where Value: Numeric & Sendable {
	public func decrease() {
		withLock { $0 -= 1 }
	}

	public func increase() {
		withLock { $0 += 1 }
	}
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Mutex where Value: Sendable {
	public var value: Value {
		withLock { $0 }
	}
}
