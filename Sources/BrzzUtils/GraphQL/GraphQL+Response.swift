import Foundation

extension GraphQL {
	public struct Response<T: Decodable & Sendable>: Decodable, Sendable {
		public let data: T?
		public let errors: [Error]? // swiftlint:disable:this discouraged_optional_collection
	}

	public struct NoResponse: Decodable, Sendable {
		public init() {}
	}
}
