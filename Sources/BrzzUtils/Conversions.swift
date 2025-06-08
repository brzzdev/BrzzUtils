import Foundation

extension Double {
	/// Returns the string representation of this double.
	public func toString() -> String {
		String(self)
	}
}

extension Int {
	/// Returns the string representation of this integer.
	public func toString() -> String {
		String(self)
	}
}

extension String {
	/// Returns the integer value of this string, or nil if invalid.
	public func toInt() -> Int? {
		Int(self)
	}

	/// Returns the double value of this string, or nil if invalid.
	public func toDouble() -> Double? {
		Double(self)
	}
}
