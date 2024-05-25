import ComposableArchitecture
import Foundation
import KeychainSwift

public struct BrzzSharedKeychainBool: PersistenceKey, Hashable {
	public typealias Value = Bool?
	
	private let key: String
	@Dependency(\.keychain)
	private var keychain
	
	public init(_ key: String) {
		self.key = key
	}
	
	public func save(_ value: Value) {
		keychain.setBool(value, key: key)
	}
	
	public func load(initialValue: Value?) -> Value? {
		guard let value = keychain.getBool(key: key) else {
			keychain.setBool(initialValue ?? nil, key: key)
			return initialValue
		}
		
		return value
	}
	
	public static func == (lhs: BrzzSharedKeychainBool, rhs: BrzzSharedKeychainBool) -> Bool {
		lhs.key == rhs.key && lhs.keychain == rhs.keychain
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(key)
		hasher.combine(keychain)
	}
}

public struct BrzzSharedKeychainCodable<Value: Codable>: PersistenceKey, Hashable {
	private let key: String
	@Dependency(\.keychain)
	private var keychain
	
	public init(_ key: String) {
		self.key = key
	}
	
	public func save(_ value: Value) {
		guard let data = PropertyListEncoder.safeEncode(value) else { return }
		keychain.setData(data, key: key)
	}
	
	public func load(initialValue: Value?) -> Value? {
		guard let value = keychain.getData(key: key) else {
			keychain.setData(PropertyListEncoder.safeEncode(initialValue) ?? nil, key: key)
			return initialValue
		}
		
		return PropertyListDecoder.safeDecode(value)
	}
	
	public static func == (lhs: BrzzSharedKeychainCodable, rhs: BrzzSharedKeychainCodable) -> Bool {
		lhs.key == rhs.key && lhs.keychain == rhs.keychain
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(key)
		hasher.combine(keychain)
	}
}

public struct BrzzSharedKeychainData: PersistenceKey, Hashable {
	public typealias Value = Data?
	
	private let key: String
	@Dependency(\.keychain)
	private var keychain
	
	public init(_ key: String) {
		self.key = key
	}
	
	public func save(_ value: Value) {
		keychain.setData(value, key: key)
	}
	
	public func load(initialValue: Value?) -> Value? {
		guard let value = keychain.getData(key: key) else {
			keychain.setData(initialValue ?? nil, key: key)
			return initialValue
		}
		
		return value
	}
	
	public static func == (lhs: BrzzSharedKeychainData, rhs: BrzzSharedKeychainData) -> Bool {
		lhs.key == rhs.key && lhs.keychain == rhs.keychain
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(key)
		hasher.combine(keychain)
	}
}

public struct BrzzSharedKeychainString: PersistenceKey, Hashable {
	public typealias Value = String?
	
	private let key: String
	@Dependency(\.keychain)
	private var keychain
	
	public init(_ key: String) {
		self.key = key
	}
	
	public func save(_ value: Value) {
		keychain.setString(value, key: key)
	}
	
	public func load(initialValue: Value?) -> Value? {
		guard let value = keychain.getString(key: key) else {
			keychain.setString(initialValue ?? nil, key: key)
			return initialValue
		}
		
		return value
	}
	
	public static func == (lhs: BrzzSharedKeychainString, rhs: BrzzSharedKeychainString) -> Bool {
		lhs.key == rhs.key && lhs.keychain == rhs.keychain
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(key)
		hasher.combine(keychain)
	}
}
