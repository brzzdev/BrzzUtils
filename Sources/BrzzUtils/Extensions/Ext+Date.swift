import Foundation

extension Date {
	public var isoString: String {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [
			.withFullDate,
			.withSpaceBetweenDateAndTime,
			.withTime,
			.withColonSeparatorInTime,
			.withFractionalSeconds,
		]
		formatter.timeZone = TimeZone.current
		return formatter.string(from: self)
	}
}
