import Combine

public typealias PassthroughSubjectOf<T> = PassthroughSubject<T, Never>
public typealias PublisherOf<T> = Publisher<T, Never>
public typealias SubjectOf<T> = CurrentValueSubject<T, Never>
