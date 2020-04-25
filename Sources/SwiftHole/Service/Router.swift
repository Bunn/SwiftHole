//
//  File.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

internal struct Environment {
    let apiToken = ""
    let host = ""
}

internal enum Router {
    case getSummary
    case getLogs
    
    var scheme: String {
        switch self {
        case .getSummary, .getLogs:
            return "http"
        }
    }
    
    var host: String {
        switch self {
        case .getSummary, .getLogs:
            return Environment().host
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
        let token = Environment().apiToken
        switch self {
        case .getSummary:
            return []
        case .getLogs:
            return [URLQueryItem(name: "getAllQueries", value: "100"),
                    URLQueryItem(name: "auth", value: token)]
        }
    }
}
