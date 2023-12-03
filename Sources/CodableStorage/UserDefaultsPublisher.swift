//
//  Created by Adam Stragner
//

import Combine
import Foundation

// MARK: - UserDefaultsPublisher

internal final class UserDefaultsPublisher<ValueType>:
    Publisher
    where
    ValueType: Equatable
{
    // MARK: Lifecycle

    internal init(
        initialValue: ValueType?,
        userDefaults: UserDefaults,
        valueKey: String
    ) {
        self.initialValue = initialValue
        self.userDefaults = userDefaults
        self.valueKey = valueKey
    }

    // MARK: Internal

    // MARK: - Publisher

    internal typealias Output = ValueType
    internal typealias Failure = Never

    internal func receive<S>(
        subscriber: S
    ) where S: Subscriber, S.Failure == Failure, S.Input == Output {
        subscriber.receive(subscription: UserDefaultsSubscription(
            subscriber: subscriber,
            userDefaults: userDefaults,
            valueKey: valueKey,
            currentValue: initialValue
        ))
    }

    // MARK: Private

    private let initialValue: ValueType?
    private let userDefaults: UserDefaults
    private let valueKey: String
}
