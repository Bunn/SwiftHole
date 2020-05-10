//
//  File.swift
//  
//
//  Created by Fernando Bunn on 10/05/2020.
//

import Foundation

public enum SwiftHoleError: Error {
    case noAPITokenProvided
    case malformedURL
    case sessionError(Error)
    case invalidResponseCode(Int)
    case invalidResponse
    case invalidDecode(Error)
}
