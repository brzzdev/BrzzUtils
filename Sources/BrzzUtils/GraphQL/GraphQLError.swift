import Foundation

public struct GraphQLError: LocalizedError, Decodable {
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
