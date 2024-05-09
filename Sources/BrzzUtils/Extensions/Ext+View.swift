import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
	public func onFirstAppear(perform action: @escaping () async -> Void) -> some View {
		modifier(FirstAppearModifier(action: action))
	}
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
