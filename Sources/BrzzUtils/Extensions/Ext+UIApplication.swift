#if os(iOS)
public import UIKit

extension UIApplication {
	public var safeKeyWindow: UIWindow? {
		Self
			.shared
			.connectedScenes
			.compactMap { ($0 as? UIWindowScene)?.keyWindow }
			.last
	}
}
#endif
