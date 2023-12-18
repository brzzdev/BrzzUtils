import ConcurrencyExtras
import IdentifiedCollections
import OSLog

/// `Logger` is a singleton that provides thread-safe logging at various levels (debug, info, error, and fault).
/// It uses `fileID` as an identifier and creates/stores a unique `os.Logger` instance for each file.
public final class Logger: Sendable {
	private static let loggers = LockIsolated<IdentifiedArrayOf<IdentifiableLogger>>([])
	
	private init() {}
	
	private static func createLogger(category: String) -> LockIsolated<os.Logger> {
		loggers.withValue { loggers in
			let logger = IdentifiableLogger(
				id: category,
				logger: LockIsolated(
					os.Logger(
						subsystem: Bundle.main.bundleIdentifier ?? "No identifier",
						category: category
					)
				)
			)
			loggers.append(logger)
			return logger.logger
		}
	}
	
	private static func log(
		level: OSLogType,
		_ message: String,
		fileID: StaticString
	) {
		let id = "\(fileID)"
		let logger = loggers[id: id]?.logger ?? createLogger(category: id)
		logger.value.log(
			level: level,
			"\(message)"
		)
	}
	
	public static func debug(
		_ message: String,
		fileID: StaticString = #fileID
	) {
		log(level: .debug, message, fileID: fileID)
	}
	
	public static func info(
		_ message: String,
		fileID: StaticString = #fileID
	) {
		log(level: .info, message, fileID: fileID)
	}
	
	public static func error(
		_ message: String,
		fileID: StaticString = #fileID
	) {
		log(level: .error, message, fileID: fileID)
	}
	
	public static func fault(
		_ message: String,
		fileID: StaticString = #fileID
	) {
		log(level: .fault, message, fileID: fileID)
	}
}

private struct IdentifiableLogger: Identifiable, Sendable {
	let id: String
	let logger: LockIsolated<os.Logger>
}

extension os.Logger {
	fileprivate init(category: String) {
		self = os.Logger(
			subsystem: Bundle.main.bundleIdentifier ?? "No identifier",
			category: category
		)
	}
}
