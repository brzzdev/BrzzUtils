import SwiftUI

public struct CloseButton: View {
	public enum Style {
		case circle
		case text
	}

	@Environment(\.dismiss)
	private var dismiss

	private let style: Style

	public init(
		style: Style = .circle
	) {
		self.style = style
	}

	public var body: some View {
		Button(
			action: {
				dismiss()
			},
			label: {
				switch style {
				case .circle:
					Image(systemName: "xmark.circle.fill")
						.font(.system(size: 20))

				case .text:
					Text("Close")
				}
			}
		)
		.keyboardShortcut(.cancelAction)
		.accessibilityLabel(Text("Close"))
	}
}
