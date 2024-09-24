@testable import BrzzUtils
import Testing

@Suite
struct ExtCollectionTests {
	@Test
	func isNotEmpty() async throws {
		// GIVEN
		let nonEmptyArray = [1, 2, 3]
		let emptyArray = [Int]()
		
		// WHEN
		let nonEmptyIsNotEmpty = nonEmptyArray.isNotEmpty
		let emptyIsNotEmpty = emptyArray.isNotEmpty
		
		// THEN
		#expect(nonEmptyIsNotEmpty)
		#expect(!emptyIsNotEmpty)
	}
	
	@Test
	func safeSubscription() {
		// GIVEN
		let array = [1, 2, 3]
		
		// WHEN
		let withinBoundsResult = array[safe: 1]
		let outOfBoundsResult = array[safe: 10]
		
		// THEN
		#expect(withinBoundsResult == 2)
		#expect(outOfBoundsResult == nil)
	}

	@Test
	func mutableCollectionSafeSubscription() {
		// GIVEN
		var array = [1, 2, 3]
		
		// WHEN
		let receivedWithinBoundsVal = array[safe: 1]
		let receivedOutOfBoundsVal = array[safe: 10]
		
		// THEN
		#expect(receivedWithinBoundsVal == 2)
		#expect(receivedOutOfBoundsVal == nil)
		
		// GIVEN
		let newWithinBoundsVal = 5
		let outOfBoundsIndex = 10
		let newOutOfBoundsVal = 4
		
		// WHEN
		array[safe: 1] = newWithinBoundsVal
		array[safe: outOfBoundsIndex] = newOutOfBoundsVal
		
		// THEN
		#expect(array[safe: 1] == newWithinBoundsVal)
		#expect(array.count == 3)  // Out-of-bounds adding doesn't expand the array
	}
}
