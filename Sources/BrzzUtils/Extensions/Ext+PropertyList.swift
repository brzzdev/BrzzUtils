import Foundation

extension PropertyListDecoder {
	public static func safeDecode<T: Decodable>(_ data: Data) -> T? {
		try? PropertyListDecoder().decode(T.self, from: data)
	}
}

extension PropertyListEncoder {
	public static func safeEncode(_ value: (some Encodable)?) -> Data? {
		guard let value else { return nil }
		return try? PropertyListEncoder().encode(value)
	}
}
