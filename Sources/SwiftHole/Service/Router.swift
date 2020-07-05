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
    case enable(Environment)
    case getHistoricalQueries(Environment)
    
    var scheme: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable,
             .enable,
             .getHistoricalQueries:
            return "http"
        }
    }
    
    var host: String {
        switch self {
        case .getSummary(let environment),
             .getLogs (let environment),
             .disable(let environment, _),
             .enable (let environment),
             .getHistoricalQueries(let environment):
            return environment.host
        }
    }
    
    var path: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable,
             .enable,
             .getHistoricalQueries:
            return "/admin/api.php"
        }
    }
    
    var port: Int? {
        switch self {
        case .getSummary(let environment),
             .getLogs (let environment),
             .disable(let environment, _),
             .enable (let environment),
             .getHistoricalQueries (let environment):
            return environment.port        
        }
    }
    
    var method: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable,
             .enable,
             .getHistoricalQueries:
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
            return [URLQueryItem(name: "auth", value: environment.apiToken ?? ""),
                    URLQueryItem(name: "disable", value: "\(seconds)")]
            
        case .enable(let environment):
            return [URLQueryItem(name: "auth", value: environment.apiToken ?? ""),
                    URLQueryItem(name: "enable", value: "")]
            
        case .getHistoricalQueries (let environment):
            return [URLQueryItem(name: "overTimeData10mins", value: ""),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
        }
    }
}
