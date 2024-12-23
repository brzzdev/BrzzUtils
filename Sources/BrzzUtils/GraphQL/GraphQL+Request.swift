import Foundation

extension GraphQL {
	public protocol Request {
		associatedtype Response: Codable & Sendable
		static var query: GraphQL.Query { get }
		var variables: [String: Any] { get }
	}
}
