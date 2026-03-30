import Foundation

extension Data {
	public var prettyPrinted: String {
		guard
			let json = try? JSONSerialization.jsonObject(with: self, options: []),
			let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		else {
			return "Invalid JSON"
		}

		return String(decoding: data, as: UTF8.self)
	}

	public var utf8String: String {
		String(decoding: self, as: UTF8.self)
	}
}
