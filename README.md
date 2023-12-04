# CodableStorage

Lightweight implementation of Apple's [@AppStorage](https://developer.apple.com/documentation/swiftui/appstorage) with a little benefits.

## Features

- [x] SwiftUI compatible
- [x] UIKit compatible

## Requirements

- iOS 13.0+
- macOS 10.15+
- watchOS 6.0+
- tvOS 12.0+

## Installation

```swift
.package(
    url: "https://github.com/0xstragner/CodableStorage",
    .upToNextMajor(from: "0.1.0")
)
```

## Usage

### SwiftUI

```swift
import SwiftUI
import CodableStorage

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
                .background(testValue % 2 == 0 ? Color.red : Color.green)

            Button(action: {
                testValue += 1
            }, label: {
                Text("Click me")
            })
        }
    }

    @CodableStorage("key", defaultValue: 0)
    private var testValue: Int
}
```

### UIKit

```swift
class Subview: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        $value.eraseToAnyPublisher().sink(receiveValue: { value in
            print(value)
        }).store(in: &cancellables)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private

    @CodableStroage("test", defaultValue: 0)
    private var value: Int

    private var cancellables: Set<AnyCancellable> = .init()
}
```

### Typed keys

```swift
extension CodableStorageValueKey {
    static let myKey = CodableStorageValueKey("mykey")
}

class Subview: UIView {
    @CodableStroage(.myKey)
    private var value: Int?
}
```

## Authors

- adam@stragner.com
