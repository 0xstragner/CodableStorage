//
//  Created by Adam Stragner
//

import Foundation

// MARK: - AnyOptional

private protocol AnyOptional {
    var isEmpty: Bool { get }
}

// MARK: - Optional + AnyOptional

extension Optional: AnyOptional {
    var isEmpty: Bool { self == nil }
}

internal func isnil(_ instance: Any) -> Bool {
    guard let _optional = instance as? AnyOptional
    else {
        return false
    }
    return _optional.isEmpty
}
