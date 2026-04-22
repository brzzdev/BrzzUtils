import Foundation

extension GraphQL {
	public protocol Request {
		associatedtype Variables: Encodable & Sendable
		associatedtype Response: Decodable & Sendable
		static var query: GraphQL.Query { get }
		var variables: Variables { get }
	}
}
