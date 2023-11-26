@_exported import Dependencies
import DependenciesMacros
@preconcurrency import OSLog

extension DependencyValues {
	/// A value for writing interpolated string messages to the unified logging system.
	public var logger: Logger {
		get { self[Logger.self] }
		set { self[Logger.self] = newValue }
	}
}

// MARK: - Logger + DependencyKey

extension Logger: DependencyKey {
	public static let liveValue = Logger()
	public static var testValue = liveValue
	
	/// A `Logger` that fails when accessed in tests.
	public static let unimplemented: Logger = {
		XCTFail(#"Unimplemented: @Dependency(\.logger)"#)
		return Logger()
	}()
}

extension Logger {
	/// Creates a `Logger` value where messages are categorized by the provided argument.
	/// The `Logger`'s subsystem is the bundle identifier.
	///
	/// You can use this subscript on the `\.logger` dependency:
	/// ```swift
	/// @Dependency(\.logger["Transactions"]) var logger
	///
	/// logger.log("Paid with bank account \(accountNumber)")
	/// ```
	public subscript(category: String) -> Logger {
		Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: category)
	}
}
