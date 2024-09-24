import Foundation

public extension Data {
	var utf8String: String {
		guard let string = String(data: self, encoding: .utf8) else {
			assertionFailure("String not correctly decoding from Data")
			return String(decoding: self, as: UTF8.self)
		}
		
		return string
	}
}
