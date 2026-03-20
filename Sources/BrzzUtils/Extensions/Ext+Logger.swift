import Foundation
import OSLog

extension Logger {
	private static let fallbackSubsystem = "dev.brzz.unknown"

	private static var subsystem: String {
		guard
			let bundleIdentifier = Bundle.main.bundleIdentifier,
			bundleIdentifier.isEmpty == false
		else {
			return fallbackSubsystem
		}

		return bundleIdentifier
	}

	/// This initializer creates a new instance of `Logger` using the `bundleIdentifier` of the main app bundle as the
	/// `subsystem`. If, for any reason, the `bundleIdentifier` is not available, it falls back to a stable default.
	public init(category: String) {
		self.init(
			subsystem: Self.subsystem,
			category: category
		)
	}

	/// Creates a `Logger` instance for a specific module.
	/// Module identification is derived from a file's path, typically the `#fileID` compiler literal.
	public static func forModule(fileID: String = #fileID) -> Logger {
		let parts = fileID.split(separator: "/")
		guard let moduleName = parts.first else {
			return Logger(category: "Unknown")
		}

		return Logger(category: String(moduleName))
	}

	public func error(_ error: Error) {
		self.error("\(error)")
	}
}
