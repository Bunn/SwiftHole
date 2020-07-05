
private enum EnableDisableMethodType {
    case enable
    case disable
}

public struct SwiftHole {
    private let environment: Environment
    private let service = Service()
    
    
    // MARK: Public Methods
    
    public init(host: String, port: Int? = nil, apiToken: String? = nil) {
        environment = Environment(host: host, port: port, apiToken: apiToken)
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
    
    public func fetchHistoricalQueries(completion: @escaping (Result<Summary, SwiftHoleError>) -> ()) {
        service.request(router: .getHistoricalQueries(environment), completion: completion)
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
