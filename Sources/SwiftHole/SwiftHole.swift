import Foundation

private enum EnableDisableMethodType {
    case enable
    case disable
}

public struct SwiftHole {
    private let environment: Environment
    private var service = Service()
    
    public var timeoutInterval: TimeInterval {
        set {
            service.timeoutInterval = newValue
        }
        get {
            return service.timeoutInterval
        }
    }
    
    
    // MARK: Public Methods
    
    public init(host: String, port: Int? = nil, apiToken: String? = nil, timeoutInterval: TimeInterval = 30, secure: Bool = false) {
        service.timeoutInterval = timeoutInterval
        environment = Environment(host: host, port: port, apiToken: apiToken, secure: secure)
    }
    
    public func fetchSummary(completion: @escaping (Result<Summary, SwiftHoleError>) -> ()) {
        service.request(router: .getSummary(environment), completion: completion)
    }
    
    public func enablePiHole(_ completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        if environment.apiToken == nil {
            completion(.failure(.noAPITokenProvided))
            return
        }
        
        service.request(router: .enable(environment)) { (result: Result<Status, SwiftHoleError>) in
            self.handleEnableDisableMethod(type: .enable, result: result, completion: completion)
        }
    }
    
    //0 seconds means PiHole will be disabled permanently
    public func disablePiHole(seconds: Int = 0, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        if environment.apiToken == nil {
            completion(.failure(.noAPITokenProvided))
            return
        }
        
        service.request(router: .disable(environment, seconds)) { (result: Result<Status, SwiftHoleError>) in
            self.handleEnableDisableMethod(type: .disable, result: result, completion: completion)
        }
    }
    
    public func fetchHistoricalQueries(completion: @escaping (Result<[DNSRequest], SwiftHoleError>) -> ()) {
        service.request(router: .getHistoricalQueries(environment)) { (result: Result<HistoricalQueries, SwiftHoleError>) in
            switch result {
            case .success(let historicalQueries):
                completion(.success(historicalQueries.requests))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: Private Methods
    
    private func handleEnableDisableMethod(type: EnableDisableMethodType, result: Result<Status, SwiftHoleError>, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        
        switch result {
        case .success(let status):
            if (type == .disable && status.isEnabled == false) ||
                (type == .enable && status.isEnabled == true) {
                completion(.success(()))
            } else {
                completion(.failure(.invalidResponse))
            }
        case .failure(let error):
            switch error {
            case .invalidDecode(_):
                /* the server returns a 200 even if the API Token is wrong
                 but it doesn't return anything to decode, so it's safe to assume there's
                 an issue with the API token here
                 */
                completion(.failure(.invalidAPIToken))
            default:
                completion(.failure(error))
            }
        }
    }
}
