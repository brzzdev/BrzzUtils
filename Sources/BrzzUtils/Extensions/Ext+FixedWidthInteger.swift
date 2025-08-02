import Foundation

extension FixedWidthInteger {
	/// Returns a random integer between Int.min and Int.max
	public static func randomFullRange() -> Int {
		.random(in: .min ... .max)
	}

	/// Returns a random integer between 0 and 9_999
	public static func randomSmall() -> Self {
		.random(in: 0 ... 9_999)
	}
}

extension BinaryFloatingPoint where RawSignificand: FixedWidthInteger {
	public static func randomFullRange() -> Self {
		.random(in: -greatestFiniteMagnitude ... greatestFiniteMagnitude)
	}

	public static func randomSmall() -> Self {
		.random(in: 0.0 ... 9_999.0)
	}
}
