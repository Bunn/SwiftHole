//
//  File.swift
//  
//
//  Created by Fernando Bunn on 31/05/2021.
//

import Foundation

@testable import SwiftHole

internal struct MockService: ServiceProtocol {
    var timeoutInterval: TimeInterval = 30
    
    func request(router: Router, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        completion(.success(()))
    }
    
    func request<T>(router: Router, completion: @escaping (Result<T, SwiftHoleError>) -> ()) where T : Decodable {
        switch router {
        case .getSummary:
            completion(.success(Summary.mockData() as! T))
        default:
            completion(.failure(.invalidResponse))
        }
    }
}
