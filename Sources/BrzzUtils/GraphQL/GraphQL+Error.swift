import Foundation

extension GraphQL {
	public struct Error: LocalizedError, Decodable {
		public let locations: [ErrorLocation]?
		public let message: String
		public let status: Int?
		
		public struct ErrorLocation: Decodable, Sendable {
			public let line: Int
			public let column: Int
		}
		
		public var errorDescription: String? {
			message
		}
	}
}
