//
//  Created by Adam Stragner
//

import Foundation

// MARK: - CodableStorageValueKey

public struct CodableStorageValueKey: RawRepresentable {
    // MARK: Lifecycle

    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Public

    public let rawValue: String
}

// MARK: ExpressibleByStringLiteral

extension CodableStorageValueKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}
