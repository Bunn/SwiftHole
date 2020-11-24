# SwiftHole
A Swift library to connect to your Pi-hole


## Installation
You can follow [Apple's documentation](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) on how to install a SPM into your project

## Authentication Token
Some methods like `fetchSummary` do not require authentication to work, but to interact with the Pi-hole server, for example, with `disablePiHole` or `enablePiHole` authentication is necessary.

There are two different ways to get your authentication token:

- /etc/pihole/setupVars.conf under WEBPASSWORD
- WebUI -> Settings -> API -> Show API Token

## Examples

- Getting Pi-hole summary:

```swift
SwiftHole(host: "192.168.1.123").fetchSummary { result in
    switch result {
        case .success(let summary):
            print("Status \(summary.status)")
                
        case .failure(let error):
            print("Error \(error)")
    }
}
```

- Disable Pi-hole for 5 seconds:

```swift
SwiftHole.init(host: "192.168.1.123", apiToken: "klaatubaradanikto")
         .disablePiHole(seconds: 5) { result in
                
    switch result {
        case .success:
            print("disabled")
                    
        case .failure(let error):
            print("Error \(error)")
    }
}
```

- Enable Pi-hole:

```swift
 SwiftHole.init(host: "192.168.1.123", apiToken: "klaatubaradanikto")
          .enablePiHole { result in
                
    switch result {
        case .success:
            print("enabled")
                
        case .failure(let error):
            print("Error \(error)")
    }
}
```

## Interface

SwiftHole has the following public interface:

```swift

public var timeoutInterval: TimeInterval { get set }

public init(host: String, port: Int? = nil, apiToken: String? = nil, timeoutInterval: TimeInterval = 30, secure: Bool = false)

public func fetchSummary(completion: @escaping (Result<Summary, SwiftHoleError>) -> ())

public func enablePiHole(_ completion: @escaping (Result<Void, SwiftHoleError>) -> ())

public func disablePiHole(seconds: Int = 0, completion: @escaping (Result<Void, SwiftHoleError>) -> ())

public func fetchList(_ listType: ListType, completion: @escaping (Result<[ListItem], SwiftHoleError>) -> ())

public func fetchHistoricalQueries(completion: @escaping (Result<[DNSRequest], SwiftHoleError>) -> ())

public func add(domain: String, to list: ListType, completion: @escaping (Result<Void, SwiftHoleError>) -> ())

public func remove(domain: String, from list: ListType, completion: @escaping (Result<Void, SwiftHoleError>) -> ())

```

