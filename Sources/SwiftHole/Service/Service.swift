//
//  File.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

internal struct Service {

    private func URLForRouter(_ router: Router) -> URL? {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        guard let url = components.url else {
            return nil
        }
        return url
    }
    
    func request(router: Router, completion: @escaping (Result<Void, SwiftHoleError>) -> ()) {
        guard let url = URLForRouter(router) else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.sessionError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if 200 ..< 300 ~= response.statusCode {
                    completion(.success(()))
                    return
                } else {
                    completion(.failure(.invalidResponseCode(response.statusCode)))
                    return
                }
            } else {
                completion(.failure(.invalidResponse))
            }

        }
        dataTask.resume()
    }
    
    func request<T: Codable>(router: Router, completion: @escaping (Result<T, SwiftHoleError>) -> ()) {
        guard let url = URLForRouter(router) else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.sessionError(error)))
                return
            }
            
            guard response != nil else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(.invalidDecode(error)))
            }
        }
        dataTask.resume()
    }
}
