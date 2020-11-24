//
//  ListType.swift
//  
//
//  Created by Fernando Bunn on 23/11/2020.
//

import Foundation

public enum ListType {
    case whitelist
    case whitelistRegex
    case blacklist
    case blacklistRegex
    
    var endpointPath: String {
        switch self {
        case .whitelist:
            return "white"
        case .whitelistRegex:
            return "regex_white"
        case .blacklist:
            return "black"
        case .blacklistRegex:
            return "regext_black"
        }
    }
}
