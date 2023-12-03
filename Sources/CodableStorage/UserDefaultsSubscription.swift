//
//  Created by Adam Stragner
//

import Combine
import Foundation

// MARK: - UserDefaultsSubscription

internal final class UserDefaultsSubscription<ValueType, SubscriberType>:
    Subscription
    where
    ValueType: Equatable,
    SubscriberType: Subscriber,
    SubscriberType.Input == ValueType,
    SubscriberType.Failure == Never
{
    // MARK: Lifecycle

    internal init(
        subscriber: SubscriberType,
        userDefaults: UserDefaults,
        valueKey: String,
        currentValue: ValueType?
    ) {
        self.subscriber = subscriber

        self.valueKey = valueKey
        self.userDefaults = userDefaults

        self.currentValue = currentValue
    }

    // MARK: Internal

    internal func request(_ demand: Subscribers.Demand) {
        guard demand > 0
        else {
            return
        }

        unsubscribeIfNeeded()
        userDefaultsDidChange(userDefaults)

        subscription = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: OperationQueue(),
            using: { [weak self] notification in
                guard let userDefaults = notification.object as? UserDefaults
                else {
                    return
                }

                self?.userDefaultsDidChange(userDefaults)
            }
        )
    }

    internal func cancel() {
        unsubscribeIfNeeded()
        subscriber = nil
    }

    // MARK: Private

    private var subscriber: SubscriberType?
    private var subscription: NSObjectProtocol? = nil

    private let userDefaults: UserDefaults
    private let valueKey: String

    private var currentValue: ValueType?

    private func userDefaultsDidChange(_ userDefaults: UserDefaults) {
        guard let subscriber, self.userDefaults.identifier == userDefaults.identifier
        else {
            return
        }

        let updatedValue = userDefaults.object(forKey: valueKey)
        guard let updatedValue = updatedValue as? ValueType, currentValue != updatedValue
        else {
            return
        }

        currentValue = updatedValue
        let _ = subscriber.receive(updatedValue)
    }

    private func unsubscribeIfNeeded() {
        guard let subscription
        else {
            return
        }

        NotificationCenter.default.removeObserver(subscription)
        self.subscription = nil
    }
}
