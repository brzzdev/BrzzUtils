#if os(iOS)
import UIKit

extension UIApplication {
	public var safeKeyWindow: UIWindow? {
		UIApplication
			.shared
			.connectedScenes
			.compactMap { ($0 as? UIWindowScene)?.keyWindow }
			.last
	}
}
#endif
