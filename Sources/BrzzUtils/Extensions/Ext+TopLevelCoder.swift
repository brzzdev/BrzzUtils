import Combine
import Foundation

extension TopLevelDecoder where Input == Data {
	public func safeDecode<T: Decodable>(_ data: Data) -> T? {
		try? decode(T.self, from: data)
	}
}

extension TopLevelEncoder where Output == Data {
	public func safeEncode(_ value: (some Encodable)?) -> Output? {
		guard let value else { return nil }
		return try? encode(value)
	}
}
