import Foundation

/// GraphQL query builder.
///
/// Example usage:
/// ```swift
///	let query = GraphQL.Query(
///		operation: "query ($id: Int)",
///		fields: [
///			.object(
///				"Media(id: $id, type: ANIME)",
///				[
///					.scalar("id"),
///					.object(
///						"title",
///						[
///							.scalar("english"),
///							.scalar("native")
///						]
///					),
///					.scalar("episodes")
///				]
///			)
///		]
///	)
/// ```
public enum GraphQL: Sendable {
	/// Represents a field in a GraphQL query.
	public enum Field: Sendable {
		/// A scalar field that represents a leaf node in the query (e.g., "id", "name").
		case scalar(String)
		/// A complex field that can contain nested fields.
		/// - Parameters:
		///   - String: The name of the field, optionally including arguments
		///   - [Field]: An array of nested fields
		indirect case object(String, [Field])
		
		/// Converts the field to its GraphQL query string representation.
		/// For scalar fields, returns just the field name.
		/// For object fields, returns the field name and its nested fields in GraphQL syntax.
		fileprivate var stringValue: String {
			switch self {
			case .scalar(let name):
				return name
				
			case let .object(name, fields):
				return
 """
 \(name) {
 \(fields.map { $0.stringValue }.joined(separator: "\n    "))
 }
 """
			}
		}
	}
	
	/// Represents a complete GraphQL query with an operation and fields.
	public struct Query: Sendable {
		/// The operation definition (e.g., "query ($id: Int)").
		private let operation: String
		/// The fields to be queried.
		private let fields: [Field]
		
		/// Converts the query to its GraphQL string representation.
		/// Includes the operation and all fields in proper GraphQL syntax.
		public var stringValue: String {
 """
 \(operation) {
 \(fields.map { $0.stringValue }.joined(separator: "\n    "))
 }
 """
		}
		
		/// Creates a new GraphQL query.
		/// - Parameters:
		///   - operation: The operation definition (e.g., "query ($id: Int)")
		///   - fields: An array of fields to be queried
		public init(
			operation: String,
			fields: [Field]
		) {
			self.operation = operation
			self.fields = fields
		}
	}
}
