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
}
