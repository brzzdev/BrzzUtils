import ConcurrencyExtras
import Foundation

extension LockIsolated {
	/// Safely reads locked value but then creates an unchecked version of this value
	/// You are then responsible for safe reading/writing of this new value
	public var unchecked: UncheckedSendable<Value> {
		withValue {
			UncheckedSendable($0)
		}
	}
}

extension LockIsolated where Value: Numeric {
	public func decrease() {
		withValue { $0 -= 1 }
	}
	
	public func increase() {
		withValue { $0 += 1 }
	}
}
