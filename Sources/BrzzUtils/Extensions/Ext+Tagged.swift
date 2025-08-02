import Foundation
import Tagged

extension Tagged where RawValue: FixedWidthInteger {
	public static func random(in range: ClosedRange<RawValue>) -> Self {
		Self(rawValue: .random(in: range))
	}
}
