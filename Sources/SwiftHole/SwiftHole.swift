public struct SwiftHole {
    
    func fetchSummary(completion: @escaping (Result<Summary, Error>) -> ()) {
        Service().request(router: .getSummary, completion: completion)
    }
    
}
