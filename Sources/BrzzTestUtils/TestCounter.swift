import ConcurrencyExtras
import XCTest

/// A helpful typealias around `LockIsolated<Int>` for use in test cases.
public typealias TestCounter = LockIsolated<Int>

extension TestCounter {
	/// Asserts whether the current value of the counter is equal to the provided value.
	/// If the values are not equal, an XCTest runtime error is thrown.
	///
	/// - Parameters:
	///   - value: The value to which the counter's value is going to be compared.
	///   - file: The file name in which failure occurred. Defaults to the file name of the test case in which this function was called.
	///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
	public func assertEqualTo(
		_ value: Int,
		file: StaticString = #file,
		line: UInt = #line
	) {
		XCTAssertEqual(self.value, value)
	}
	
	/// Decreases the counter safely by 1.
	public func decrease() {
		withValue {
			$0 -= 1
		}
	}
	
	/// Increases the counter safely by 1.
	public func increase() {
		withValue {
			$0 += 1
		}
	}
}
