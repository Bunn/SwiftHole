public struct SwiftHole {
    let environment: Environment
    let service = Service()
    
    public init(host: String, apiToken: String? = nil) {
        environment = Environment(host: host, apiToken: apiToken)
    }

    public func fetchSummary(completion: @escaping (Result<Summary, Error>) -> ()) {
        service.request(router: .getSummary(environment), completion: completion)
    }
    
}
