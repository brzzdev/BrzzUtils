import Dependencies
public import Foundation

extension Date {
	public enum BrzzDateStyle {
		/// Returns a localized string showing only the day and month
		/// E.g - "16/03" for UK locale, "03/16" for US locale
		case dayMonth
		/// Returns a localized string showing the day, month, and time
		/// E.g - "16/03, 13:00" for UK locale, "03/16, 1:00 PM" for US locale
		case dayMonthTime
		/// Returns an ISO 8601 formatted string representation of the date
		/// E.g - "1970-01-01 00:00:00.000"
		case iso
	}

	/// The day and month in the current locale's order and calendar, which `.dayMonth` and
	/// `.dayMonthTime` share so the two cannot drift apart.
	private static var dayMonthStyle: FormatStyle {
		@Dependency(\.locale) var locale
		@Dependency(\.timeZone) var timeZone
		return FormatStyle(locale: locale, calendar: locale.calendar, timeZone: timeZone)
			.day(.twoDigits)
			.month(.twoDigits)
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

	/// Converts `self` to its textual representation in one of the custom styles. The exact format
	/// depends on the user's preferences.
	/// - Parameters:
	///   - style: The custom style used.
	/// - Returns: A `String` describing `self`.
	public func formatted(
		style: BrzzDateStyle,
	) -> String {
		switch style {
		case .dayMonth:
			return formatted(Self.dayMonthStyle)

		case .dayMonthTime:
			return formatted(Self.dayMonthStyle.hour().minute())

		case .iso:
			let formatter = ISO8601DateFormatter()
			formatter.formatOptions = [
				.withFullDate,
				.withSpaceBetweenDateAndTime,
				.withTime,
				.withColonSeparatorInTime,
				.withFractionalSeconds,
			]
			@Dependency(\.timeZone) var timeZone
			formatter.timeZone = timeZone
			return formatter.string(from: self)
		}
	}
}
