import Foundation

extension MainActor {
	public static func asap(execute block: @escaping @MainActor @Sendable () -> Void) {
		if DispatchQueue.getSpecific(key: key) == value {
			assumeIsolated {
				block()
			}
		} else {
			DispatchQueue.main.async {
				Self.assumeIsolated {
					block()
				}
			}
		}
	}

	public static func now<R: Sendable>(execute block: @MainActor @Sendable () -> R) -> R {
		if DispatchQueue.getSpecific(key: key) == value {
			return assumeIsolated {
				block()
			}
		}

		return DispatchQueue.main.sync {
			Self.assumeIsolated {
				block()
			}
		}
	}
}

private let key: DispatchSpecificKey<UInt8> = {
	let key = DispatchSpecificKey<UInt8>()
	DispatchQueue.main.setSpecific(key: key, value: value)
	return key
}()

private let value: UInt8 = 0
