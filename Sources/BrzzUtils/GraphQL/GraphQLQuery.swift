import Foundation

public protocol GraphQLQuery {
	associatedtype Response: Codable & Sendable
	static var query: GraphQL.Query { get }
	var variables: [String: Any] { get }
}
