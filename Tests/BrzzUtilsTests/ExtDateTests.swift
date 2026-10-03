@testable import BrzzUtils
import Dependencies
import Foundation
import Testing

struct ExtDateTests {
	/// 16 March 2026, 13:00 UTC.
	private let date = Date(timeIntervalSince1970: 1_773_666_000)

	@Test(arguments: [
		("en_GB", "16/03"),
		("en_US", "03/16"),
		// Persian calendar: 16 March 2026 is 25 Esfand 1404.
		("fa_IR", "۱۲/۲۵"),
	])
	func dayMonthFollowsLocaleOrder(identifier: String, expected: String) {
		// GIVEN
		let locale = Locale(identifier: identifier)
		let timeZone = TimeZone.gmt

		// WHEN
		let formatted = withDependencies {
			$0.locale = locale
			$0.timeZone = timeZone
		} operation: {
			date.formatted(style: .dayMonth)
		}

		// THEN
		#expect(formatted == expected)
	}

	@Test(arguments: [
		("en_GB", "16/03, 13:00"),
		// ICU separates the day period with a narrow no-break space.
		("en_US", "03/16, 1:00\u{202F}PM"),
	])
	func dayMonthTimeFollowsLocaleHourCycle(identifier: String, expected: String) {
		// GIVEN
		let locale = Locale(identifier: identifier)
		let timeZone = TimeZone.gmt

		// WHEN
		let formatted = withDependencies {
			$0.locale = locale
			$0.timeZone = timeZone
		} operation: {
			date.formatted(style: .dayMonthTime)
		}

		// THEN
		#expect(formatted == expected)
	}

	@Test(arguments: [
		(0, "GMT", "1970-01-01 00:00:00.000"),
		(1_773_666_000, "Asia/Kolkata", "2026-03-16 18:30:00.000"),
		// The stored `Double` sits just below .123, so truncating would print .122.
		(1_773_666_000.123, "GMT", "2026-03-16 13:00:00.123"),
		// Rounds to the nearest millisecond, carrying into the next second.
		(1_773_666_000.9996, "GMT", "2026-03-16 13:00:01.000"),
	])
	func isoMatchesFixedShape(
		timeIntervalSince1970: TimeInterval,
		timeZoneIdentifier: String,
		expected: String,
	) throws {
		// GIVEN
		let date = Date(timeIntervalSince1970: timeIntervalSince1970)
		let timeZone = try #require(TimeZone(identifier: timeZoneIdentifier))

		// WHEN
		let formatted = withDependencies {
			$0.timeZone = timeZone
		} operation: {
			date.formatted(style: .iso)
		}

		// THEN
		#expect(formatted == expected)
	}
}
