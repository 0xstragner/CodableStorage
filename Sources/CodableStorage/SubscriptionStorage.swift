//
//  Created by Adam Stragner
//

import Foundation
import Combine

internal final class SubscriptionStorage<T>: ObservableObject where T: Codable, T: Equatable {
    // MARK: Lifecycle

    internal init(
        encoder: JSONEncoder,
        decoder: JSONDecoder,
        valueKey: CodableStorageValueKey,
        defaultValue: T,
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
        self.valueKey = valueKey

        self.defaultValue = defaultValue

        if let data = userDefaults.data(forKey: valueKey.rawValue),
           let decodedValue = try? decoder.decode(T.self, from: data)
        {
            self.currentValue = decodedValue
        } else {
            self.currentValue = nil
        }

        self.encoder = encoder
        self.decoder = decoder

        subscribe(UserDefaultsPublisher(
            initialValue: try? encoder.encode(defaultValue),
            userDefaults: userDefaults,
            valueKey: valueKey.rawValue
        ).eraseToAnyPublisher())
    }

    // MARK: Internal

    internal let userDefaults: UserDefaults
    internal let valueKey: CodableStorageValueKey
    internal let defaultValue: T

    internal var value: T { currentValue ?? defaultValue }

    internal func update(_ currentValue: T) {
        let key = valueKey.rawValue
        guard !isnil(currentValue)
        else {
            userDefaults.removeObject(forKey: key)
            return
        }

        guard let encodedValue = try? encoder.encode(currentValue)
        else {
            return
        }

        userDefaults.setValue(encodedValue, forKey: key)
    }

    internal func eraseToAnyPublisher() -> AnyPublisher<T, Never> {
        let decoder = decoder
        let publisher = UserDefaultsPublisher(
            initialValue: try? encoder.encode(defaultValue),
            userDefaults: userDefaults,
            valueKey: valueKey.rawValue
        )

        return publisher.compactMap({ data in
            guard let value = try? decoder.decode(T.self, from: data)
            else {
                return nil
            }

            return value
        }).eraseToAnyPublisher()
    }

    // MARK: Private

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private var currentValue: T?
    private var cancellables: Set<AnyCancellable> = .init()

    private func subscribe(_ publisher: AnyPublisher<Data, Never>) {
        publisher
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.receive(value)
            })
            .store(in: &cancellables)
    }

    private func receive(_ data: Data) {
        guard let decodedValue = try? decoder.decode(T.self, from: data)
        else {
            return
        }

        if value != decodedValue {
            objectWillChange.send()
        }

        currentValue = decodedValue
    }
}


