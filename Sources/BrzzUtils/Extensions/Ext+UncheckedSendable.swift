import Combine

extension AnyPublisher: @retroactive @unchecked Sendable where Output: Sendable,
	Failure: Sendable {}

@available(iOS 18.0, *)
extension AsyncPublisher: @retroactive @unchecked Sendable where P: Sendable, Element: Sendable,
	Failure: Sendable {}

extension PassthroughSubject: @retroactive @unchecked Sendable where Output: Sendable,
	Failure: Sendable {}
