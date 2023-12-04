//
//  Created by Adam Stragner
//

import Foundation
import ObjectiveC
import Combine
import OSLog

internal extension UserDefaults {
    var identifier: String {
        guard let ivar = class_getInstanceVariable(UserDefaults.self, "_identifier_"),
              let value = object_getIvar(self, ivar) as? NSString
        else {
            #if DEBUG
            fatalError("UserDefaults API has been changed")
            #else
            return UUID().uuidString
            #endif
        }

        return value as String
    }
}

// MARK: - log

internal enum log {
    // MARK: Internal

    static func critical(_ message: String) {
        if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
            codableStorage.critical("\(message)")
        } else {
            print(message)
        }
    }

    // MARK: Private

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    private static let codableStorage = Logger(
        subsystem: "com.stragner.codable-storage",
        category: "codable-storage"
    )
}

internal extension JSONDecoder {
    static let codableStorage = JSONDecoder()

    func _decode<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable {
        do {
            return try decode(type, from: data)
        } catch {
            log.critical("Decoding error: `\(error)`")
            return nil
        }
    }
}

internal extension JSONEncoder {
    static let codableStorage = JSONEncoder()

    func _encode<T>(_ value: T) -> Data? where T: Encodable {
        do {
            return try encode(value)
        } catch {
            log.critical("Encoding error: `\(error)`")
            return nil
        }
    }
}
