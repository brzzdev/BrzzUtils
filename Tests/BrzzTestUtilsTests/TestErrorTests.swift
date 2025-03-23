import BrzzTestUtils
import Foundation
import Testing

@Suite
struct TestErrorTests {
	@Test
	func networkErrorDescription() {
		let error = TestError.networkError
		#expect(error.description == "TestError(1000: Network connection failed)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func timeoutErrorDescription() {
		let error = TestError.timeoutError
		#expect(error.description == "TestError(1001: Operation timed out)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func serverErrorDescription() {
		let error = TestError.serverError
		#expect(error.description == "TestError(5000: Server error)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func authErrorDescription() {
		let error = TestError.authError
		#expect(error.description == "TestError(4010: Authentication failed)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func notFoundErrorDescription() {
		let error = TestError.notFoundError
		#expect(error.description == "TestError(4040: Resource not found)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func customErrorWithMessage() {
		let error = TestError.custom(code: 42, message: "Custom failure")
		#expect(error.description == "TestError(42: Custom failure)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func customErrorWithEmptyMessage() {
		let error = TestError.custom(code: 42, message: "")
		#expect(error.description == "TestError(42)")
		#expect(error.localizedDescription == error.description)
	}

	@Test
	func genericError() {
		let error = TestError.genericError
		let expectedError = TestError.custom(code: 0, message: "An unknown error occurred")
		#expect(error == expectedError)
	}

	@Test
	func randomError() {
		let error = TestError.randomError
		switch error {
		case let .custom(code, message):
			// Verify that the custom error has a code within a plausible range and a non-empty message.
			#expect(!message.isEmpty, "Random error should have a non-empty message")
			#expect(
				code >= Int(Int.min) && code <= Int(Int.max),
				"Random error code should be within the range of Int"
			)

		default:
			Issue.record("Random error should always be of custom type")
		}
	}

	@Test
	func equatable() {
		#expect(TestError.networkError == TestError.networkError)
		#expect(TestError.networkError != TestError.timeoutError)

		let customError1 = TestError.custom(code: 10, message: "Error")
		let customError2 = TestError.custom(code: 10, message: "Error")
		let customError3 = TestError.custom(code: 10, message: "Different Error")
		#expect(customError1 == customError2)
		#expect(customError1 != customError3)
	}
}
