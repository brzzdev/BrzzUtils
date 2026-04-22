import Foundation

extension GraphQL {
	/// Wire-format envelope sent to a GraphQL endpoint: the operation string and its variables.
	public struct Envelope<Variables: Encodable>: Encodable {
		public let query: String
		public let variables: Variables

		public init(query: String, variables: Variables) {
			self.query = query
			self.variables = variables
		}

		public init<Request: GraphQL.Request>(_ request: Request) where Request.Variables == Variables {
			self.init(query: Request.query.stringValue, variables: request.variables)
		}
	}
}
