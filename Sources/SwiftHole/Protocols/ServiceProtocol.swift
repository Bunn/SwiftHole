//
//  ServiceProtocol.swift
//  
//
//  Created by Fernando Bunn on 31/05/2021.
//

import Foundation

protocol ServiceProtocol {
    var timeoutInterval: TimeInterval { get set}
    
    func request(router: Router, completion: @escaping (Result<Void, SwiftHoleError>) -> ());
    func request<T: Decodable>(router: Router, completion: @escaping (Result<T, SwiftHoleError>) -> ())
}
