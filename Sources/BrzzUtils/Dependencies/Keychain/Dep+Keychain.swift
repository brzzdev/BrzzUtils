import Dependencies
import DependenciesMacros
import Foundation
import KeychainSwift
import Synchronization

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
	public var getData: @Sendable (_ key: String) -> Data?
	public var setData: @Sendable (Data?, _ key: String) -> Bool = { _, _ in
		unimplemented("\(Self.self).setData", placeholder: false)
	}
}

extension Keychain: DependencyKey {
	public static let liveValue: Self = {
		let keychain = LockIsolated(KeychainSwift())
		return Self(
			clear: { keychain.withValue { $0.clear() } },
			delete: { key in
				keychain.withValue { $0.delete(key) }
			},
			getData: { key in
				keychain.withValue { $0.getData(key) }
			},
			setData: { value, key in
				if let value {
					keychain.withValue { $0.set(value, forKey: key) }
				} else {
					keychain.withValue { $0.delete(key) }
				}
			}
		)
	}()
	
	public static let testValue = Self()
	
	public static let noop = Self(
		clear: { false },
		delete: { _ in false },
		getData: { _ in nil },
		setData: { _, _ in false }
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
