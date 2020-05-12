
public struct SwiftHole {
    private let environment: Environment
    private let service = Service()
    
    public init(host: String, apiToken: String? = nil) {
        environment = Environment(host: host, apiToken: apiToken)
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
            switch result {
            case .success(let status):
                if status.isEnabled == true {
                    completion(.success(()))
                } else {
                    completion(.failure(.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //0 seconds means PiHole will be disabled permanently
    public func disablePiHole(seconds: Int = 0, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        if environment.apiToken == nil {
            completion(.failure(.noAPITokenProvided))
            return
        }
        
        service.request(router: .disable(environment, seconds)) { (result: Result<Status, SwiftHoleError>) in
            switch result {
            case .success(let status):
                if status.isEnabled == false {
                    completion(.success(()))
                } else {
                    completion(.failure(.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
