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
	public var boolForKey: @Sendable (String) -> Bool? = { _ in false }
	public var clear: @Sendable () -> Void
	public var dataForKey: @Sendable (String) -> Data?
	public var stringForKey: @Sendable (String) -> String? = { _ in "" }
	public var remove: @Sendable (String) async -> Void
	public var setBool: @Sendable (Bool?, _ key: String) async -> Void
	public var setData: @Sendable (Data?, _ key: String) async -> Void
	public var setString: @Sendable (String?, _ key: String) async -> Void
}

extension Keychain: DependencyKey {
	public static let liveValue: Self = {
		let keychain = KeychainSwift()
		return Self(
			boolForKey: { keychain.getBool($0) }, 
			clear: { keychain.clear() },
			dataForKey: { keychain.getData($0) },
			stringForKey: { keychain.get($0) },
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
	
	public static var testValue = Self()
	
	public static let noop = Self { _ in
		false
	} clear: {
		
	} dataForKey: { _ in
		nil
	} stringForKey: { _ in
		nil
	} remove: { _ in
		
	} setBool: { _, _ in
		
	} setData: { _, _ in
		
	} setString: { _, _ in
		
	}
}
