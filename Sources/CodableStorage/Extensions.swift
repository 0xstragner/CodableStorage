//
//  Created by Adam Stragner
//

import Foundation
import ObjectiveC
import Combine

internal extension UserDefaults {
    var identifier: String {
        guard let ivar = class_getInstanceVariable(UserDefaults.self, "_identifier_"),
              let value = object_getIvar(self, ivar) as? NSString
        else {
            return UUID().uuidString
        }

        return value as String
    }
}

internal extension JSONDecoder {
    static let codableStorage = JSONDecoder()
}

internal extension JSONEncoder {
    static let codableStorage = JSONEncoder()
}
