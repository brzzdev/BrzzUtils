import Dependencies
import DependenciesMacros
import Foundation

extension DependencyValues {
	public var keychain: Keychain {
		get { self[Keychain.self] }
		set { self[Keychain.self] = newValue }
	}
}

@DependencyClient
public struct Keychain: Sendable {
	private let id = UUID()

	public var clear: @Sendable () -> Bool = {
		unimplemented("\(Self.self).clear", placeholder: false)
	}

	public var delete: @Sendable (_ key: String) -> Bool = { _ in
		unimplemented("\(Self.self).delete", placeholder: false)
	}

	public var get: @Sendable (_ key: String) -> Data?
	public var set: @Sendable (Data?, _ key: String) -> Bool = { _, _ in
		unimplemented("\(Self.self).set", placeholder: false)
	}
}

extension Keychain: DependencyKey {
	public static let liveValue: Self = {
		let keychain = _Keychain()
		return Self(
			clear: { keychain.clear() },
			delete: { key in
				keychain.delete(key)
			},
			get: { key in
				keychain.get(key)
			},
			set: { value, key in
				if let value {
					keychain.set(value, forKey: key)
				} else {
					keychain.delete(key)
				}
			}
		)
	}()

	public static let testValue = Self()

	public static let noop = Self(
		clear: { false },
		delete: { _ in false },
		get: { _ in nil },
		set: { _, _ in false }
	)
}

extension Keychain: Hashable {
	public static func == (lhs: Keychain, rhs: Keychain) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

private struct _Keychain: Sendable {
	private enum Const {
		static let accessible = kSecAttrAccessible as String
		static let accessibleAfterFirstUnlock = kSecAttrAccessibleAfterFirstUnlock as String
		static let attrAccount = kSecAttrAccount as String
		static let klass = kSecClass as String
		static let matchLimit = kSecMatchLimit as String
		static let returnData = kSecReturnData as String
		static let secUseDataProtectionKeychain = kSecUseDataProtectionKeychain as String
		static let valueData = kSecValueData as String
	}

	private let lock = NSLock()

	func clear() -> Bool {
		lock.withLock {
			SecItemDelete(
				[
					Const.klass: kSecClassGenericPassword,
				] as CFDictionary
			) == noErr
		}
	}

	func delete(_ key: String) -> Bool {
		lock.withLock {
			SecItemDelete(getQuery(key: key)) == noErr
		}
	}

	func get(_ key: String) -> Data? {
		lock.withLock {
			let query = getQuery(
				key: key,
				adding: [
					Const.matchLimit: kSecMatchLimitOne,
					Const.returnData: kCFBooleanTrue!,
				]
			)

			var result: AnyObject?

			let resultCode = withUnsafeMutablePointer(to: &result) {
				SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
			}

			guard resultCode == noErr else { return nil }

			return result as? Data
		}
	}

	func set(_ value: Data, forKey key: String) -> Bool {
		_ = delete(key)

		return lock.withLock {
			let resultCode = SecItemAdd(
				getQuery(
					key: key,
					adding: [
						Const.accessible: Const.accessibleAfterFirstUnlock,
						Const.valueData: value,
					]
				),
				nil
			)
			return resultCode == noErr
		}
	}

	private func getQuery(
		key: String,
		adding additionalQueries: [String: Any] = [:]
	) -> CFDictionary {
		var query: [String: Any] = [
			Const.attrAccount: key,
			Const.klass: kSecClassGenericPassword,
			Const.secUseDataProtectionKeychain: true,
		]
		for (key, value) in additionalQueries {
			query[key] = value
		}
		return query as CFDictionary
	}
}
