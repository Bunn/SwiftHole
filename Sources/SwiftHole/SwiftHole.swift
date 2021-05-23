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
    
    /// Initialize SwiftHole
    /// - Parameters:
    ///   - host: Host IP Address
    ///   - port: Optional host port
    ///   - apiToken: Optional API Token, required for some methods like disable/enable
    ///   - timeoutInterval: Interval for timeout
    ///   - secure: Boolean to indicate if the pi-hole is using HTTPS or not
    public init(host: String, port: Int? = nil, apiToken: String? = nil, timeoutInterval: TimeInterval = 30, secure: Bool = false) {
        service.timeoutInterval = timeoutInterval
        environment = Environment(host: host, port: port, apiToken: apiToken, secure: secure)
    }
    
    
    /// Fetches pi-hole summary and assigns it to its summary property
    public func fetchSummary(completion: @escaping (Result<Summary, SwiftHoleError>) -> ()) {
        service.request(router: .getSummary(environment), completion: completion)
    }
    
    /// Enable pi-hole. Does nothing if pi-hole is already enabled
    public func enablePiHole(_ completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        if environment.apiToken == nil {
            completion(.failure(.noAPITokenProvided))
            return
        }
        
        service.request(router: .enable(environment)) { (result: Result<Status, SwiftHoleError>) in
            self.handleEnableDisableMethod(type: .enable, result: result, completion: completion)
        }
    }
    
    
    /// Disable pi-hole.
    /// - Parameters:
    ///   - seconds: Number in seconds for the pi-hole to get back online once disabled. 0 seconds means it will be disabled permanently
    public func disablePiHole(seconds: Int = 0, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        if environment.apiToken == nil {
            completion(.failure(.noAPITokenProvided))
            return
        }
        
        service.request(router: .disable(environment, seconds)) { (result: Result<Status, SwiftHoleError>) in
            self.handleEnableDisableMethod(type: .disable, result: result, completion: completion)
        }
    }
    
    
    /// Fetches the pi-hole black or white lists
    /// - Parameters:
    ///   - listType: Type of list you want to fetch
    public func fetchList(_ listType: ListType, completion: @escaping (Result<[ListItem], SwiftHoleError>) -> ()) {
        service.request(router: .getList(environment, listType)) { (result: Result<List, SwiftHoleError>) in
            switch result {
            case .success(let list):
                completion(.success(list.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// Fetches the amount of queries made over time
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
    
    /// Add a domain to a list
    /// - Parameters:
    ///   - domain: Domain address
    ///   - list: List type.
    public func add(domain: String, to list: ListType, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        service.request(router: .addToList(environment, list, domain)) { (result: Result<EditListResponse, SwiftHoleError>) in
            switch result {
            case .success(let response):
                if response.success {
                    completion(.success(()))
                } else {
                    completion(.failure(.cantAddNewListItem(response.message ?? "Unknown Error")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Remove a domain to a list
    /// - Parameters:
    ///   - domain: Domain address
    ///   - list: List type.
    public func remove(domain: String, from list: ListType, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {        
        service.request(router: .removeFromList(environment, list, domain)) { (result: Result<EditListResponse, SwiftHoleError>) in
            switch result {
            case .success(let response):
                if response.success {
                    completion(.success(()))
                } else {
                    completion(.failure(.cantAddNewListItem(response.message ?? "Unknown Error")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches the percentage of queries type made
    public func fetchQueryTypePercentages(completion: @escaping (Result<[QueryPercentage], SwiftHoleError>) -> ()) {
        service.request(router: .getQueryTypes(environment)) { (result: Result<QueryPercentage.List, SwiftHoleError>) in
            switch result {
            case .success(let list):
                completion(.success(list.values))
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
