import Foundation
@_exported import OSLog

extension Logger: @unchecked Sendable {}

extension Logger {
	private static var subsystem: String {
		guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
			assertionFailure("bundleIdentifier should not be nil")
			return "No subsystem"
		}
		
		return bundleIdentifier
	}
	
	/// This initializer creates a new instance of `Logger` using the `bundleIdentifier` of the main app bundle as the
	/// `subsystem`. If, for any reason, the `bundleIdentifier` is not available, it defaults to a string "No subsystem".
	public init(category: String) {
		self.init(
			subsystem: Self.subsystem,
			category: category
		)
	}
	
	public func error(_ error: Error) {
		self.error("\(error)")
	}
	
	/// Creates a `Logger` instance for a specific module.
	/// Module identification is derived from a file's path, typically the `#fileID` compiler literal.
	public static func forModule(fileID: String = #fileID) -> Logger {
		let parts = fileID.split(separator: "/")
		guard let moduleName = parts.first else {
			assertionFailure("moduleName should not be nil")
			return Logger(category: "No category")
		}
		
		return Logger(category: String(moduleName))
	}
}
