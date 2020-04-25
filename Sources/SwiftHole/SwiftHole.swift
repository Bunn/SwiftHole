public struct SwiftHole {

    public var host: String {
        set {
            Environment().saveHost(newValue)
        }
        get {
            Environment().host
        }
    }
    public init() {}

    public func fetchSummary(completion: @escaping (Result<Summary, Error>) -> ()) {
        Service().request(router: .getSummary, completion: completion)
    }
    
}
