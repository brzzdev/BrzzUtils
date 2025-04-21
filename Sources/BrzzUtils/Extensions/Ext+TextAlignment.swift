import SwiftUI

extension TextAlignment {
	public func toAlignment() -> Alignment {
		switch self {
		case .leading:
			.leading
		case .center:
			.center
		case .trailing:
			.trailing
		}
	}
}
