import Foundation

extension GraphQL {
	public struct Response<T: Decodable>: Decodable {
		public let data: T?
		public let errors: [Error]?
	}
	
	public struct NoResponse: Decodable {}
}
