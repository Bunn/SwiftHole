
public struct SwiftHole {
    private let environment: Environment
    private let service = Service()
    
    public init(host: String, apiToken: String? = nil) {
        environment = Environment(host: host, apiToken: apiToken)
    }

    public func fetchSummary(completion: @escaping (Result<Summary, SwiftHoleError>) -> ()) {
        service.request(router: .getSummary(environment), completion: completion)
    }
    
    public func disablePiHole(seconds: Int, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
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
