import Foundation
public import Synchronization

@available(visionOS 2.0, *)
extension Mutex where Value: Numeric & Sendable {
	public func decrease() {
		withLock { $0 -= 1 }
	}

	public func increase() {
		withLock { $0 += 1 }
	}
}

@available(visionOS 2.0, *)
extension Mutex where Value: Sendable {
	public var value: Value {
		withLock { $0 }
	}
}
