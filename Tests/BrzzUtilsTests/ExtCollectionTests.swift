@testable import BrzzUtils
import XCTest

final class ExtCollectionTests: XCTestCase {
	func testIsNotEmpty() {
		// GIVEN
		let nonEmptyArray = [1, 2, 3]
		let emptyArray: [Int] = []
		
		// WHEN
		let nonEmptyIsNotEmpty = nonEmptyArray.isNotEmpty
		let emptyIsNotEmpty = emptyArray.isNotEmpty
		
		// THEN
		XCTAssertTrue(nonEmptyIsNotEmpty)
		XCTAssertFalse(emptyIsNotEmpty)
	}
	
	func testSafeSubscription() {
		// GIVEN
		let array = [1, 2, 3]
		
		// WHEN
		let withinBoundsResult = array[safe: 1]
		let outOfBoundsResult = array[safe: 10]
		
		// THEN
		XCTAssertEqual(withinBoundsResult, 2)
		XCTAssertNil(outOfBoundsResult)
	}
	
	func testMutableCollectionSafeSubscription() {
		// GIVEN
		var array = [1, 2, 3]
		
		// WHEN
		let receivedWithinBoundsVal = array[safe: 1]
		let receivedOutOfBoundsVal = array[safe: 10]
		
		// THEN
		XCTAssertEqual(receivedWithinBoundsVal, 2)
		XCTAssertNil(receivedOutOfBoundsVal)
		
		// GIVEN
		let newWithinBoundsVal = 5
		let outOfBoundsIndex = 10
		let newOutOfBoundsVal = 4
		
		// WHEN
		array[safe: 1] = newWithinBoundsVal
		array[safe: outOfBoundsIndex] = newOutOfBoundsVal
		
		// THEN
		XCTAssertEqual(array[safe: 1], newWithinBoundsVal)
		XCTAssertEqual(array.count, 3)  // Out-of-bounds adding doesn't expand the array
	}
}
