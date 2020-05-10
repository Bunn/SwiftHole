
public struct SwiftHole {
    let environment: Environment
    let service = Service()
    
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
        service.request(router: .disable(environment, 10), completion: completion)
    }
}
