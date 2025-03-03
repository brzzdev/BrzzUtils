import ComposableArchitecture
import OSLog

extension DependencyValues {
	public var osLogStore: OSLogStore.DependencyKey {
		get { self[OSLogStore.DependencyKey.self] }
		set { self[OSLogStore.DependencyKey.self] = newValue }
	}
}

extension OSLogStore {
	@DependencyClient
	public struct DependencyKey: Sendable {
		public var _getLogs: @Sendable (
			_ bundleIdentifier: String,
			_ scope: OSLogStore.Scope
		) async throws -> [OSLogStore.Output]

		public func getLogs(
			bundleIdentifier: String = Bundle.main.bundleIdentifier!,
			scope: OSLogStore.Scope = .currentProcessIdentifier
		) async throws -> [OSLogStore.Output] {
			try await _getLogs(
				bundleIdentifier: bundleIdentifier,
				scope: scope
			)
		}
	}
}

extension OSLogStore.DependencyKey: DependencyKey {
	public static let liveValue = Self(
		_getLogs: { bundleIdentifier, scope in
			let store = try OSLogStore(scope: scope)
			let position = store.position(timeIntervalSinceLatestBoot: 1)
			return try store
				.getEntries(at: position)
				.compactMap { $0 as? OSLogEntryLog }
				.filter { $0.subsystem == bundleIdentifier }
				.map {
					OSLogStore.Output(
						category: $0.category,
						date: $0.date.formatted(date: .numeric, time: .standard),
						message: $0.composedMessage
					)
				}
		}
	)

	public static let testValue = Self()
}

extension OSLogStore {
	public struct Output: Equatable, Sendable {
		public let category: String
		public let date: String
		public let message: String

		public init(category: String, date: String, message: String) {
			self.category = category
			self.date = date
			self.message = message
		}
	}
}
