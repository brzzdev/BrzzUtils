#if DEBUG
import BrzzUtils
import Foundation

/// An enum-based custom error type that conforms to Equatable for testing purposes
public enum TestError: Error, CustomStringConvertible, Equatable {
	case authError
	case custom(code: Int, message: String)
	case networkError
	case notFoundError
	case serverError
	case timeoutError

	/// A generic error representing an unknown error
	public static let genericError = TestError.custom(
		code: 0,
		message: "An unknown error occurred"
	)

	public var description: String {
		switch self {
		case .networkError:
			"TestError(1000: Network connection failed)"

		case .timeoutError:
			"TestError(1001: Operation timed out)"

		case .serverError:
			"TestError(5000: Server error)"

		case .authError:
			"TestError(4010: Authentication failed)"

		case .notFoundError:
			"TestError(4040: Resource not found)"

		case let .custom(code, message):
			message.isEmpty ? "TestError(\(code))" : "TestError(\(code): \(message))"
		}
	}

	public var localizedDescription: String {
		description
	}
}

extension TestError {
	/// Returns a random error for testing purposes
	public static func random() -> TestError {
		.custom(code: Int.randomFullRange(), message: UUID().uuidString)
	}
}
#endif
