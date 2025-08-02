import Foundation

extension String {
	public static func random(
		length: Int = Int.random(in: 1 ... 20)
	) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0 ..< length).map { _ in letters.randomElement()! })
	}
}

extension [String] {
	public static func random(
		count: Int = Int.random(in: 1 ... 20)
	) -> [String] {
		return (0 ..< count).map { _ in
			String.random()
		}
	}
}
