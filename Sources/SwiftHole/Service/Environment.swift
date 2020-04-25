//
//  File.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

internal struct Environment {
    private static let hostKey = "swiftHole-hostKey"
    
    var apiToken = ""
    
    var host: String {
        UserDefaults.standard.string(forKey: Environment.hostKey) ?? ""
    }
    
    func saveHost(_ host: String) {
        UserDefaults.standard.set(host, forKey: Environment.hostKey)
    }
}
