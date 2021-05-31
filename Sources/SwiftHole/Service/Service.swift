//
//  File.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

internal struct Service: ServiceProtocol {
    
    var timeoutInterval: TimeInterval = 30
    
    
    // MARK: Public Methods
    
    func request(router: Router, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        runDataTask(with: router) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(()))
                return
                
            }
        }
    }
    
    func request<T: Decodable>(router: Router, completion: @escaping (Result<T, SwiftHoleError>) -> ()) {
        runDataTask(with: router) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(.invalidDecode(error)))
            }
        }
    }
    
    
    // MARK: Private Methods
    
    private func URLForRouter(_ router: Router) -> URL? {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.port = router.port
        components.queryItems = router.parameters
        guard let url = components.url else {
            return nil
        }
        return url
    }
    
    private func runDataTask(with router: Router, completionHandler: @escaping (Data?, URLResponse?, SwiftHoleError?) -> Void) {
        guard let url = URLForRouter(router) else {
            completionHandler(nil, nil, SwiftHoleError.malformedURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        let session = URLSession(configuration: .default)
        urlRequest.timeoutInterval = timeoutInterval
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let error = error {
                completionHandler(nil, nil, .sessionError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if 200 ..< 300 ~= response.statusCode {
                    completionHandler(data, response, nil)
                    return
                } else {
                    completionHandler(data, response, .invalidResponseCode(response.statusCode))
                    return
                }
            } else {
                completionHandler(data, response, .invalidResponse)
                return
            }
        })
        
        dataTask.resume()
    }
}
