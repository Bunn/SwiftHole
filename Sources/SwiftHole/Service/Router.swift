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
    case disable(Environment, Int)
    
    var scheme: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable:
            return "http"
        }
    }
    
    var host: String {
        switch self {
        case .getSummary(let environment),
             .getLogs (let environment),
             .disable(let environment, _):
            return environment.host
        }
    }
    
    var path: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable:
            return "/admin/api.php"
        }
    }
    
    var method: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable:
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
        case .disable(let environment, let seconds):
            return [URLQueryItem(name: "disable", value: "\(seconds)"),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]

        }
    }
}
