import Foundation

extension Encodable {
	public var prettyPrinted: String {
		do {
			let encoder = JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			let data = try encoder.encode(self)
			return data.utf8String
		} catch {
			return "Failed to prettyPrint encode \(String(describing: type(of: self))): \(error)"
		}
	}
}
