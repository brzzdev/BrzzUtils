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

	/// Generates a random date.
	///
	/// Creates a random `Date` instance by generating a random time interval
	/// since the Unix epoch (January 1, 1970, 00:00:00 UTC).
	///
	/// - Returns: A randomly generated `Date` instance.
	///
	/// - Note: The generated date will be between January 1, 1970 and
	///   approximately February 7, 2106 due to the `UInt32` range limitation.
	public static func random() -> Date {
		Date(timeIntervalSince1970: .random(in: 0 ..< TimeInterval(UInt32.max)))
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
