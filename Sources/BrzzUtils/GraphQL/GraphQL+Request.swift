import Foundation

extension GraphQL {
	public protocol Request {
		associatedtype Response: Decodable & Sendable
		static var query: GraphQL.Query { get }
		var variables: GraphQL.Dictionary { get }
	}
}
