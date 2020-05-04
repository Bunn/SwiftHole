//
//  File.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

internal enum Router {
    case getSummary(Environment)
    case getLogs(Environment)
    
    var scheme: String {
        switch self {
        case .getSummary, .getLogs:
            return "http"
        }
    }
    
    var host: String {
        switch self {
        case .getSummary(let environment), .getLogs (let environment):
            return environment.host
        }
    }
    
    var path: String {
        switch self {
        case .getSummary, .getLogs:
            return "/admin/api.php"
        }
    }
    
    var method: String {
        switch self {
        case .getSummary, .getLogs:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getSummary:
            return []
        case .getLogs (let environment):
            return [URLQueryItem(name: "getAllQueries", value: "100"),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
        }
    }
}
