import Dependencies
import DependenciesMacros
import Foundation

extension DependencyValues {
	public var userDefaultsProvider: UserDefaults {
		get { self[UserDefaults.self] }
		set { self[UserDefaults.self] = newValue }
	}
}

extension UserDefaults: DependencyKey, @unchecked Sendable {
	public static var liveValue = UserDefaults.standard
	
	public static var testValue = mock
	
	public static let mock = MockUserDefaults() as UserDefaults
}

public final class MockUserDefaults: UserDefaults {
	convenience init() {
		self.init(suiteName: "Mock User Defaults")!
	}
	
	override init?(suiteName suitename: String?) {
		UserDefaults().removePersistentDomain(forName: suitename!)
		super.init(suiteName: suitename)
	}
}
