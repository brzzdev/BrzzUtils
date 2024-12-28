import Foundation

extension GraphQL {
	public protocol Request {
		associatedtype Response: Decodable
		static var query: GraphQL.Query { get }
		var variables: [String: Any] { get }
	}
}
