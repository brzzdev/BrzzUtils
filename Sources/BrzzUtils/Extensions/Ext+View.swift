import SwiftUI

extension View {
	public func alignFrame(_ alignment: TextAlignment) -> some View {
		frame(maxWidth: .infinity, alignment: alignment.toAlignment())
			.multilineTextAlignment(alignment)
	}

	public func onFirstAppear(perform action: @escaping () async -> Void) -> some View {
		modifier(FirstAppearModifier(action: action))
	}
}

private struct FirstAppearModifier: ViewModifier {
	let action: () async -> Void
	@State
	private var isFirstAppearance = true

	func body(content: Content) -> some View {
		content
			.task {
				if isFirstAppearance {
					isFirstAppearance = false
					await action()
				}
			}
	}
}
