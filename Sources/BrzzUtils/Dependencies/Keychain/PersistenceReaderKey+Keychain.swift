import ComposableArchitecture
import Foundation
import KeychainSwift

public typealias SharedKeychain<T: Codable & Equatable> = PersistenceKeyDefault<KeychainKey<T>>

public struct KeychainKey<Value: Codable & Equatable>: PersistenceKey, Hashable {
	private let cancelBag = CancelBag()
	private let didSave = PassthroughSubjectOf<Value?>()
	private let key: String
	@Dependency(\.keychain)
	private var keychain
	
	public init(_ key: String) {
		self.key = key
	}
	
	public func save(_ value: Value) {
		guard let data = JSONEncoder.safeEncode(value) else { return }
		if keychain.setData(data, key: key) {
			didSave.send(value)
		}
	}
	
	public func load(initialValue: Value?) -> Value? {
		guard let value = keychain.getData(key: key) else {
			if let initialValue,
				 let value = JSONEncoder.safeEncode(initialValue) {
				if keychain.setData(value, key: key) {
					didSave.send(initialValue)
				}
			} else {
				if keychain.setData(nil, key: key) {
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
	) -> Shared<Value>.Subscription {
		didSave
			.removeDuplicates()
			.sink { newValue in
				didSet(newValue)
			}
			.store(in: cancelBag)
		return Shared.Subscription {
			cancelBag.cancelAll()
		}
	}
	
	public static func == (lhs: KeychainKey, rhs: KeychainKey) -> Bool {
		lhs.key == rhs.key && lhs.keychain == rhs.keychain
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(key)
		hasher.combine(keychain)
	}
}
