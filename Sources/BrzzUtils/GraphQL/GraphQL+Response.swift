import Foundation

extension GraphQL {
	public struct Response<T: Decodable & Sendable>: Decodable, Sendable {
		public let data: T?
		public let errors: [Error]?
	}

	public struct NoResponse: Decodable, Sendable {}
}
