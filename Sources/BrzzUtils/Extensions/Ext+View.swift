import SwiftUI

extension View {
	public func alignFrame(_ alignment: TextAlignment) -> some View {
		frame(maxWidth: .infinity, alignment: alignment.toAlignment())
			.multilineTextAlignment(alignment)
	}

	public func onFirstAppear(perform action: @escaping () async -> Void) -> some View {
		modifier(FirstAppearModifier(action: action))
	}

	public func readFrame(
		in coordinateSpace: CoordinateSpace = .global,
		onChange: @escaping (CGRect) -> Void
	) -> some View {
		background(
			GeometryReader { gp in
				Color.clear
					.preference(
						key: FramePreferenceKey.self,
						value: gp.frame(in: coordinateSpace)
					)
			}
		)
		.onPreferenceChange(FramePreferenceKey.self, perform: onChange)
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

private struct FramePreferenceKey: PreferenceKey {
	static let defaultValue = CGRect.zero

	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
