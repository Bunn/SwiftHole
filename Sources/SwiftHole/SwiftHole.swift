public struct SwiftHole {
    
    public func fetchSummary(completion: @escaping (Result<Summary, Error>) -> ()) {
        Service().request(router: .getSummary, completion: completion)
    }
    
}
