import Foundation

extension Int {
	/// Returns a random integer between Int.min and Int.max
	public static var randomFullRange: Int {
		return .random(in: .min ... .max)
	}
}
