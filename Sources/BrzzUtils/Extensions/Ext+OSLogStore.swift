import OSLog

extension OSLogStore {
	public static func getLogs(
		bundleIdentifier: String = Bundle.main.bundleIdentifier!,
		for scope: OSLogStore.Scope = .currentProcessIdentifier
	) async -> Result<[String], Error> {
		Result {
			let store = try OSLogStore(scope: scope)
			let position = store.position(timeIntervalSinceLatestBoot: 1)
			return try store
				.getEntries(at: position)
				.compactMap { $0 as? OSLogEntryLog }
				.filter { $0.subsystem == bundleIdentifier }
				.map {
					"[\($0.date.formatted(date: .numeric, time: .standard))] [\($0.category)] \($0.composedMessage)"
				}
		}
	}
}
