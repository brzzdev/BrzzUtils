import Foundation

extension CaseIterable {
	public static func random() -> Self {
		allCases.randomElement()!
	}
}
