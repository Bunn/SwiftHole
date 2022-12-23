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
    case getQueryTypes(Environment)
    case getHistoricalQueries(Environment)
    case getList(Environment, ListType)
    case addToList(Environment, ListType, String)
    case removeFromList(Environment, ListType, String)
    
    var scheme: String {
        switch self {
        case .getSummary(let environment),
             .getLogs (let environment),
             .disable(let environment, _),
             .enable (let environment),
             .getQueryTypes (let environment),
             .getHistoricalQueries(let environment),
             .getList(let environment, _),
             .addToList(let environment, _, _),
             .removeFromList(let environment, _, _):
            return environment.secure ? "https" : "http"
        }
    }
    
    var host: String {
        switch self {
        case .getSummary(let environment),
             .getLogs (let environment),
             .disable(let environment, _),
             .enable (let environment),
             .getQueryTypes (let environment),
             .getHistoricalQueries(let environment),
             .getList(let environment, _),
             .addToList(let environment, _, _),
             .removeFromList(let environment, _, _):
            return environment.host
        }
    }
    
    var path: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable,
             .enable,
             .getQueryTypes,
             .getHistoricalQueries,
             .getList,
             .addToList,
             .removeFromList:
            return "/admin/api.php"
        }
    }
    
    var port: Int? {
        switch self {
        case .getSummary(let environment),
             .getLogs (let environment),
             .disable(let environment, _),
             .enable (let environment),
             .getQueryTypes (let environment),
             .getHistoricalQueries (let environment),
             .getList(let environment, _),
             .addToList(let environment, _, _),
             .removeFromList(let environment, _, _):
            return environment.port
        }
    }
    
    var method: String {
        switch self {
        case .getSummary,
             .getLogs,
             .disable,
             .enable,
             .getQueryTypes,
             .getHistoricalQueries:
            return "GET"
        case .getList,
             .addToList,
             .removeFromList:
            return "POST"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getSummary (let environment):
            return [URLQueryItem(name: "summaryRaw", value: ""),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
            
        case .getLogs (let environment):
            return [URLQueryItem(name: "getAllQueries", value: "100"),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
            
        case .disable(let environment, let seconds):
            return [URLQueryItem(name: "auth", value: environment.apiToken ?? ""),
                    URLQueryItem(name: "disable", value: "\(seconds)")]
            
        case .enable(let environment):
            return [URLQueryItem(name: "auth", value: environment.apiToken ?? ""),
                    URLQueryItem(name: "enable", value: "")]
            
        case .getQueryTypes(let environment):
            return [URLQueryItem(name: "auth", value: environment.apiToken ?? ""),
                    URLQueryItem(name: "getQueryTypes", value: "")]
            
        case .getHistoricalQueries(let environment):
            return [URLQueryItem(name: "overTimeData10mins", value: ""),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
            
        case .getList(let environment, let listType):
            return [URLQueryItem(name: "list", value: listType.endpointPath),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
            
        case .addToList(let environment, let listType, let domain):
            return [URLQueryItem(name: "list", value: listType.endpointPath),
                    URLQueryItem(name: "add", value: domain),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
            
        case .removeFromList(let environment, let listType, let domain):
            return [URLQueryItem(name: "list", value: listType.endpointPath),
                    URLQueryItem(name: "sub", value: domain),
                    URLQueryItem(name: "auth", value: environment.apiToken ?? "")]
        }
    }
}
