@testable import BrzzTestUtils
import XCTest

final class TestUtilsTests: XCTestCase {
	private var counter: TestCounter!
	
	override func setUp() {
		counter = TestCounter(0)
	}
	
	override func tearDown() {
		counter = nil
	}
	
	func testIncrease() {
		counter.increase()
		counter.assertEqualTo(1)
	}
	
	func testDecrease() {
		counter.increase()
		counter.increase()
		counter.decrease()
		counter.assertEqualTo(1)
	}
	
	func testConcurrentIncrease() async {
		await withTaskGroup(of: Void.self) { group in
			for _ in 1...1000 {
				group.addTask { [self] in
					counter.increase()
				}
			}
		}
		counter.assertEqualTo(1000)
	}
	
	func testConcurrentDecrease() async {
		counter = TestCounter(1000)
		
		await withTaskGroup(of: Void.self) { group in
			for _ in 1...1000 {
				group.addTask { [self] in
					counter.decrease()
				}
			}
		}
		counter.assertEqualTo(0)
	}
	
	func testConcurrentIncreaseAndDecrease() async {
		await withTaskGroup(of: Void.self) { group in
			for _ in 1...1000 {
				group.addTask { [self] in
					counter.increase()
					counter.decrease()
				}
			}
		}
		counter.assertEqualTo(0)
	}
}
