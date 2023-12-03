//
//  Created by Adam Stragner
//

import SwiftUI
import UIKit
import Combine

// MARK: - CodableStroage

@propertyWrapper
public struct CodableStroage<ValueType>: DynamicProperty
    where
    ValueType: Codable,
    ValueType: Equatable
{
    // MARK: Lifecycle

    public init(
        _ valueKey: CodableStorageValueKey,
        defaultValue: ValueType,
        userDefaults: UserDefaults? = nil,
        decoder: JSONDecoder? = nil,
        encoder: JSONEncoder? = nil
    ) {
        self.init(
            valueKey,
            defaultValue: defaultValue,
            userDefaults: userDefaults ?? .standard,
            decoder: decoder ?? .codableStorage,
            encoder: encoder ?? .codableStorage
        )
    }

    public init(
        _ valueKey: CodableStorageValueKey,
        defaultValue: ValueType = nil,
        userDefaults: UserDefaults? = nil,
        decoder: JSONDecoder? = nil,
        encoder: JSONEncoder? = nil
    ) where ValueType: ExpressibleByNilLiteral {
        self.init(
            valueKey,
            defaultValue: defaultValue,
            userDefaults: userDefaults ?? .standard,
            decoder: decoder ?? .codableStorage,
            encoder: encoder ?? .codableStorage
        )
    }

    private init(
        _ valueKey: CodableStorageValueKey,
        defaultValue: ValueType,
        userDefaults: UserDefaults,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) {
        self.storage = .init(
            encoder: encoder,
            decoder: decoder,
            valueKey: valueKey,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
    }

    // MARK: Public

    public var wrappedValue: ValueType {
        get { storage.value }
        nonmutating set { storage.update(newValue) }
    }

    public var projectedValue: CodableStroage<ValueType> { self }

    public var defaultValue: ValueType { storage.defaultValue }
    public var valueKey: CodableStorageValueKey { storage.valueKey }

    // MARK: Private

    @ObservedObject
    private var storage: SubscriptionStorage<ValueType>
}

extension CodableStroage {
    func eraseToAnyPublisher() -> AnyPublisher<ValueType, Never> {
        storage.eraseToAnyPublisher()
    }
}
