import Combine
import ComposableArchitecture
import Foundation

public typealias BrzzKeychainBool = PersistenceKeyDefault<BrzzSharedKeychainBool>
public typealias BrzzKeychainCodable<T: Codable> = PersistenceKeyDefault<BrzzSharedKeychainCodable<T>>
public typealias BrzzKeychainData = PersistenceKeyDefault<BrzzSharedKeychainData>
public typealias BrzzKeychainString = PersistenceKeyDefault<BrzzSharedKeychainString>
