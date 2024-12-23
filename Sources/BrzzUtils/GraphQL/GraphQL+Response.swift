import Foundation

extension GraphQL {
	public struct Response<T: Codable>: Decodable {
		public let data: T?
		public let errors: [Error]?
	}
	
	public struct NoResponse: CodableEquatableSendable {}
}
