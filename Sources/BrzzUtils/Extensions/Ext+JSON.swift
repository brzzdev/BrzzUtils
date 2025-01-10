import Foundation

extension JSONDecoder {
	public static func safeDecode<T: Decodable>(_ data: Data) -> T? {
		try? JSONDecoder().decode(T.self, from: data)
	}
}

extension JSONEncoder {
	public static func safeEncode(_ value: (some Encodable)?) -> Data? {
		guard let value else { return nil }
		return try? JSONEncoder().encode(value)
	}
}
