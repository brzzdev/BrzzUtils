import Dependencies
import DependenciesMacros
import Foundation

extension DependencyValues {
	public var userDefaults: UserDefaults.Dependency {
		get { self[UserDefaults.Dependency.self] }
		set { self[UserDefaults.Dependency.self] = newValue }
	}
}

extension UserDefaults {
	@DependencyClient
	public struct Dependency: Sendable {
		public var boolForKey: @Sendable (String) -> Bool = { _ in false }
		public var dataForKey: @Sendable (String) -> Data?
		public var doubleForKey: @Sendable (String) -> Double = { _ in 0 }
		public var integerForKey: @Sendable (String) -> Int = { _ in 0 }
		public var stringForKey: @Sendable (String) -> String? = { _ in "" }
		public var remove: @Sendable (String) async -> Void
		public var setBool: @Sendable (Bool?, _ key: String) async -> Void
		public var setData: @Sendable (Data?, _ key: String) async -> Void
		public var setDouble: @Sendable (Double?, _ key: String) async -> Void
		public var setInteger: @Sendable (Int?, _ key: String) async -> Void
		public var setString: @Sendable (String?, _ key: String) async -> Void
	}
}

extension UserDefaults.Dependency: DependencyKey {
	public static let liveValue: Self = {
		let defaults = {
			@Dependency(\.userDefaultsProvider)
			var userDefaultsProvider
			return userDefaultsProvider
		}
		return Self(
			boolForKey: { defaults().bool(forKey: $0) },
			dataForKey: { defaults().data(forKey: $0) },
			doubleForKey: { defaults().double(forKey: $0) },
			integerForKey: { defaults().integer(forKey: $0) },
			stringForKey: { defaults().string(forKey: $0) },
			remove: { defaults().removeObject(forKey: $0) },
			setBool: { defaults().set($0, forKey: $1) },
			setData: { defaults().set($0, forKey: $1) },
			setDouble: { defaults().set($0, forKey: $1) },
			setInteger: { defaults().set($0, forKey: $1) },
			setString: { defaults().set($0, forKey: $1) }
		)
	}()
	
	public static let testValue = Self()
	
	public static let noop = Self { _ in
		false
	} dataForKey: { _ in
		nil
	} doubleForKey: { _ in
		0
	} integerForKey: { _ in
		0
	} stringForKey: { _ in
		nil
	} remove: { _ in
		
	} setBool: { _, _ in
		
	} setData: { _, _ in
		
	} setDouble: { _, _ in
		
	} setInteger: { _, _ in
		
	} setString: { _, _ in
		
	}
}
