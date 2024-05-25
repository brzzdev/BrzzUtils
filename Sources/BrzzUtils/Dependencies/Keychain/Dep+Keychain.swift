import Dependencies
import DependenciesMacros
import Foundation
import KeychainSwift

extension DependencyValues {
	public var keychain: Keychain {
		get { self[Keychain.self] }
		set { self[Keychain.self] = newValue }
	}
}

@DependencyClient
public struct Keychain: Sendable {
	private let id = UUID()
	
	public var clear: @Sendable () -> Void
	public var getBool: @Sendable (_ key: String) -> Bool?
	public var getData: @Sendable (_ key: String) -> Data?
	public var getString: @Sendable (_ key: String) -> String?
	public var remove: @Sendable (_ key: String) -> Void
	public var setBool: @Sendable (Bool?, _ key: String) -> Void
	public var setData: @Sendable (Data?, _ key: String) -> Void
	public var setString: @Sendable (String?, _ key: String) -> Void
}

extension Keychain: DependencyKey {
	public static let liveValue: Self = {
		let keychain = KeychainSwift()
		return Self(
			clear: { keychain.clear() },
			getBool: { keychain.getBool($0) },
			getData: { keychain.getData($0) },
			getString: { keychain.get($0) },
			remove: { keychain.delete($0) },
			setBool: { value, key in
				if let value {
					keychain.set(value, forKey: key)
				} else {
					keychain.delete(key)
				}
			},
			setData: { value, key in
				if let value {
					keychain.set(value, forKey: key)
				} else {
					keychain.delete(key)
				}
			},
			setString: { value, key in
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
		clear: {},
		getBool: { _ in nil },
		getData: { _ in nil },
		getString: { _ in nil },
		remove: { _ in },
		setBool: { _, _ in },
		setData: { _, _ in },
		setString: { _, _ in }
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
