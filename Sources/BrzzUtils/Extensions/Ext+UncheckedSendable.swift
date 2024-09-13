import Combine

extension PassthroughSubject: @retroactive @unchecked Sendable where Output: Sendable, Failure: Sendable {}
