import Dependencies
import Foundation

extension Date {
	public enum BrzzDateStyle {
		/// Returns a localized string showing only the day and month
		/// E.g - "16/03" for UK locale
		case dayMonth
		/// Returns a localized string showing the day, month, and time
		/// E.g - "16/03 13:00" for UK locale
		case dayMonthTime
		/// Returns an ISO 8601 formatted string representation of the date
		/// E.g - "1970-01-01 00:00:00.000"
		case iso
	}

	/// Returns a random Date between Date.distantPast and Date.distantFuture
	public static var randomFullRange: Date {
		let minTime = Date.distantPast.timeIntervalSinceReferenceDate
		let maxTime = Date.distantFuture.timeIntervalSinceReferenceDate
		let randomTimeInterval = TimeInterval.random(in: minTime ... maxTime)
		return Date(timeIntervalSinceReferenceDate: randomTimeInterval)
	}

	/// Converts `self` to its textual representation that contains both the date and time parts. The exact format depends on the user's preferences.
	/// - Parameters:
	///   - style: The custom style used.
	/// - Returns: A `String` describing `self`.
	public func formatted(
		style: BrzzDateStyle
	) -> String {
		switch style {
		case .dayMonth:
			let formatter = DateFormatter()
			formatter.setLocalizedDateFormatFromTemplate("dd/MM")
			return formatter.string(from: self)

		case .dayMonthTime:
			let formatter = DateFormatter()
			formatter.setLocalizedDateFormatFromTemplate("dd/MM HH:mm")
			return formatter.string(from: self)

		case .iso:
			let formatter = ISO8601DateFormatter()
			formatter.formatOptions = [
				.withFullDate,
				.withSpaceBetweenDateAndTime,
				.withTime,
				.withColonSeparatorInTime,
				.withFractionalSeconds,
			]
			@Dependency(\.timeZone)
			var timeZone
			formatter.timeZone = timeZone
			return formatter.string(from: self)
		}
	}
}
