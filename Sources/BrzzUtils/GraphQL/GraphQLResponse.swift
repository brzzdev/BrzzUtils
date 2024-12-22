import Foundation

public struct GraphQLResponse<T: Codable>: Decodable {
	public let data: T?
	public let errors: [GraphQLError]?
}
