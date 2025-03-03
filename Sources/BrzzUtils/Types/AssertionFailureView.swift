import SwiftUI

public struct AssertionFailureView: View {
	public init(message: String = "") {
		assertionFailure(message)
	}

	public var body: some View {
		EmptyView()
	}
}
