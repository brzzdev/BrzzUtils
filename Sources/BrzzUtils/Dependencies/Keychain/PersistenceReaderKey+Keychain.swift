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
	
	public func save(
		_ value: Value,
		context: SaveContext,
		continuation: SaveContinuation
	) {
		guard let data = JSONEncoder.safeEncode(value) else {
			assertionFailure("Failed to encode - \(value)")
			continuation.resume()
			return
		}
		if keychain.set(data, key: key) {
			didSave.send(value)
		}
		continuation.resume()
	}
	
	public func load(
		context: LoadContext<Value>,
		continuation: LoadContinuation<Value>
	) {
		guard let value = keychain.get(key: key),
					let value: Value = JSONDecoder.safeDecode(value) else {
			if let initialValue = context.initialValue,
				 let value = JSONEncoder.safeEncode(initialValue) {
				if keychain.set(value, key: key) {
					didSave.send(initialValue)
				}
			} else {
				if keychain.set(nil, key: key) {
					didSave.send(nil)
				}
			}
			continuation.resumeReturningInitialValue()
			return
		}
		
		continuation.resume(returning: value)
	}
	
	public func subscribe(
		context: LoadContext<Value>,
		subscriber: SharedSubscriber<Value>
	) -> SharedSubscription {
		didSave
			.removeDuplicates()
			.sink { newValue in
				subscriber.yield(with: Result { (newValue) })
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
