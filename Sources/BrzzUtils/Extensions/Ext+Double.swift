import Foundation

extension Double {
	/// Returns a random Double between -Double.greatestFiniteMagnitude and
	/// Double.greatestFiniteMagnitude.
	public static var randomFullRange: Double {
		.random(in: -.greatestFiniteMagnitude ... .greatestFiniteMagnitude)
	}
}
