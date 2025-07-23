import Foundation

extension Data {
	public var prettyPrinted: String {
		guard
			let json = try? JSONSerialization.jsonObject(with: self, options: []),
			let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
			let jsonString = String(data: data, encoding: .utf8) else {
			return "Invalid JSON"
		}

		return jsonString
	}

	public var utf8String: String {
		guard let string = String(data: self, encoding: .utf8) else {
			assertionFailure("String not correctly decoding from Data")
			return String(decoding: self, as: UTF8.self)
		}

		return string
	}
}
