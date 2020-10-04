//
//  Environment.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

internal struct Environment {
    var host: String
    var port: Int?
    var apiToken: String?
    var secure: Bool = false
}
