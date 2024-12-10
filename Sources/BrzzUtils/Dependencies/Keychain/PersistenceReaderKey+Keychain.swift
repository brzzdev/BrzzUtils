import Combine
import ComposableArchitecture
import Foundation

public typealias SharedKeychain<T: Codable & Equatable> = _SharedKeyDefault<KeychainKey<T>>

public struct KeychainKey<Value: Codable & Equatable & Sendable>: SharedKey {
	private let cancelBag = CancelBag()
	private let didSave = PassthroughSubject<Value?, Never>()
	private let key: String
	@Dependency(\.keychain)
	private var keychain
	
	public var id: KeychainKeyID {
		KeychainKeyID(key: key, keychain: keychain)
	}
	
	public init(_ key: String) {
		self.key = key
	}
	
	public func save(_ value: Value, immediately: Bool) {
		guard let data = JSONEncoder.safeEncode(value) else { return }
		if keychain.set(data, key: key) {
			didSave.send(value)
		}
	}
	
	public func load(initialValue: Value?) -> Value? {
		guard let value = keychain.get(key: key) else {
			if let initialValue,
				 let value = JSONEncoder.safeEncode(initialValue) {
				if keychain.set(value, key: key) {
					didSave.send(initialValue)
				}
			} else {
				if keychain.set(nil, key: key) {
					didSave.send(nil)
				}
			}
			return initialValue
		}
		
		return JSONDecoder.safeDecode(value)
	}
	
	public func subscribe(
		initialValue: Value?,
		didSet: @escaping (Value?) -> Void
	) -> SharedSubscription {
		didSave
			.removeDuplicates()
			.sink { newValue in
				didSet(newValue)
			}
			.store(in: cancelBag)
		return SharedSubscription {
			cancelBag.cancelAll()
		}
	}
}

public struct KeychainKeyID: Hashable {
	fileprivate let key: String
	fileprivate let keychain: Keychain
}
