import Foundation

extension GraphQL {
	public struct Error: Decodable, LocalizedError {
		public struct ErrorLocation: Decodable, Sendable {
			public let line: Int
			public let column: Int
		}

		public let locations: [ErrorLocation]?
		public let message: String
		public let status: Int?

		public var errorDescription: String? {
			message
		}
	}
}
