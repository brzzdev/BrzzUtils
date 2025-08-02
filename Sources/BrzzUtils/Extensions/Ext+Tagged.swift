import Foundation
import Tagged

extension Tagged where RawValue: FixedWidthInteger {
	public static func random(
		in range: ClosedRange<RawValue> = 0 ... 9_999
	) -> Self {
		Self(rawValue: .random(in: range))
	}

	/// Returns a random integer between Int.min and Int.max
	public static func randomFullRange() -> Int {
		.random(in: .min ... .max)
	}

	/// Returns a random integer between 0 and 9_999
	public static func randomSmall() -> Self {
		.random(in: 0 ... 9_999)
	}
}

extension Tagged where RawValue: BinaryFloatingPoint, RawValue.RawSignificand: FixedWidthInteger {
	public static func random(
		in range: ClosedRange<RawValue> = 0.0 ... 9_999.0
	) -> Self {
		Self(rawValue: .random(in: range))
	}

	/// Returns a random value in the full floating-point range
	public static func randomFullRange() -> Self {
		Self(rawValue: .random(in: -RawValue.greatestFiniteMagnitude ... RawValue
				.greatestFiniteMagnitude
		))
	}

	/// Returns a random value between 0.0 and 9_999.0
	public static func randomSmall() -> Self {
		.random(in: 0.0 ... 9_999.0)
	}
}
