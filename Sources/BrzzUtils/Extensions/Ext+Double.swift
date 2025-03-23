import Foundation

extension Double {
	/// Returns a random Double between -Double.greatestFiniteMagnitude and Double.greatestFiniteMagnitude.
	public static var randomFullRange: Double {
		return .random(in: -.greatestFiniteMagnitude ... .greatestFiniteMagnitude)
	}
}
