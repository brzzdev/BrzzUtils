import Foundation

extension GraphQL {
	public struct Error: Decodable, LocalizedError {
		public struct ErrorLocation: Decodable, Sendable {
			public let line: Int
			public let column: Int
		}

		public let locations: [ErrorLocation]? // swiftlint:disable:this discouraged_optional_collection
		public let message: String
		public let status: Int?

		public var errorDescription: String? {
			message
		}
	}
}
