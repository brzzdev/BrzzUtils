import ConcurrencyExtras
import OSLog

/// Custom logger struct to make logging easier and more convenient in the application.
/// For use at the individual file level, it will automatically include #fileID
public struct Logger: Sendable {
	/// An instance of `os.Logger`. Each instance of `Logger` struct contains an `os.Logger`
	/// that is used for the actual logging. This instance is private and thus cannot be accessed
	/// outside of this struct.
	private let logger: LockIsolated<os.Logger>
	
	/// Initializes a new instance of `Logger` struct.
	///
	/// This initializer creates a new `os.Logger` with given `fileID` and uses the bundle identifier
	/// of the application as the subsystem. If the bundle identifier is not found, "No identifier" is used as a fallback.
	/// It uses the given fileID as the category of the `os.Logger`.
	///
	/// - Parameter fileID: Used as the category of the `os.Logger`.
	public init(fileID: String = #fileID) {
		logger = LockIsolated(
			os.Logger(
				subsystem: Bundle.main.bundleIdentifier ?? "No identifier",
				category: "\(fileID)"
			)
		)
	}
	
	/// Logs a string interpolation at the `default` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.log("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.log("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.log("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func log(_ message: String) {
		logger.value.log("\(message)")
	}
	
	/// Logs a string interpolation at the specified log level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     let errorLevel = .fault
	///     logger.log(level: errorLevel, "A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.log(
	///       level: .debug,
	///       "An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///
	///     logger.log(
	///       level: errorLevel,
	///       "A unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameters:
	///   - level: Logging level.
	///   - message: A string interpolation.
	public func log(level: OSLogType, _ message: String) {
		logger.value.log(level: level, "\(message)")
	}
	
	/// An alias for `debug`. Logs a string interpolation at the debug level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.trace("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.trace("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.trace("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func trace(_ message: String) {
		logger.value.trace("\(message)")
	}
	
	/// Logs a string interpolation at the `debug` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.debug("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.debug("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.debug("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func debug(_ message: String) {
		logger.value.debug("\(message)")
	}
	
	/// Logs a string interpolation at the `info` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.info("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.info("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.info("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func info(_ message: String) {
		logger.value.info("\(message)")
	}
	
	/// Logs a string interpolation at the `default` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.notice("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.notice("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.notice("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func notice(_ message: String) {
		logger.value.notice("\(message)")
	}
	
	/// An alias for `error`. Logs a string interpolation at the `error` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.warning("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.warning("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.warning("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func warning(_ message: String) {
		logger.value.warning("\(message)")
	}
	
	/// Logs a string interpolation at the `error` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.error("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.error("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.error("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func error(_ message: String) {
		logger.value.error("\(message)")
	}
	
	/// Logs a string interpolation at the most severe level: `fault`.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.critical("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.critical("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.critical("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func critical(_ message: String) {
		logger.value.critical("\(message)")
	}
	
	/// Logs a string interpolation at the `fault` level.
	///
	/// Values that can be interpolated include signed and unsigned Swift integers, Floats,
	/// Doubles, Bools, Strings, NSObjects, UnsafeRaw(Buffer)Pointers, values conforming to
	/// `CustomStringConvertible` like Arrays and Dictionaries, and metatypes like
	/// `type(of: c)`, `Int.self`.
	///
	/// Examples
	/// ========
	///
	///     let logger = Logger()
	///     logger.fault("A string interpolation \(x)")
	///
	/// Formatting Interpolated Expressions and Specifying Privacy
	/// ==========================================================
	///
	/// Formatting and privacy options for the interpolated values can be passed as arguments
	/// to the interpolations. These are optional arguments. When not specified, they will be set to their
	/// default values.
	///
	///     logger.fault("An unsigned integer \(x, format: .hex, align: .right(columns: 10))")
	///     logger.fault("An unsigned integer \(x, privacy: .private)")
	///
	/// - Warning: Do not explicity create OSLogMessage. Instead pass a string interpolation.
	///
	/// - Parameter message: A string interpolation.
	public func fault(_ message: String) {
		logger.value.fault("\(message)")
	}
}
