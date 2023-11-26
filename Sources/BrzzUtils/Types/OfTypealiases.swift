import Combine

/// A type-aliased `PassthroughSubject` where the `Failure` type is always `Never`.
/// This is useful in cases where the subject should never fail.
public typealias PassthroughSubjectOf<T> = PassthroughSubject<T, Never>

/// A type-aliased `Publisher` where the `Failure` type is always `Never`.
/// This is useful in cases where the publisher should never fail.
public typealias PublisherOf<T> = Publisher<T, Never>

/// A type-aliased `Result`, used for computations that may fail or return a value.
/// This is useful when you require result type that throws a standard `Swift.Error`.
public typealias ResultOf<T> = Result<T, Error>

/// A type-aliased `CurrentValueSubject` where the `Failure` type is always `Never`.
/// This is useful in cases where the subject should never fail.
public typealias SubjectOf<T> = CurrentValueSubject<T, Never>
