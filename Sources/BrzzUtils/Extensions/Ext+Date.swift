import Dependencies
import Foundation

extension Date {
	/// Returns an ISO 8601 formatted string representation of the date
	///
	/// This method creates a string with full date, time with colons,
	/// fractional seconds, and a space between date and time components.
	/// The string is formatted using the current time zone.
	///
	/// - Returns: A string like "1970-01-01 00:00:00.000" in the current time zone
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

	/// Returns a localized string showing only the day and month
	///
	/// This property creates a representation of the date showing only the day
	/// and month in a format appropriate for the user's current locale.
	///
	/// - Returns: A localized string representing the day and month (e.g., "16/03" for UK locale)
	public var localizedDayMonthString: String {
		let formatter = DateFormatter()
		@Dependency(\.locale)
		var locale

		formatter.dateFormat = DateFormatter.dateFormat(
			fromTemplate: "dM",
			options: 0,
			locale: locale
		) ?? "dd/MM"

		return formatter.string(from: self)
	}
}
