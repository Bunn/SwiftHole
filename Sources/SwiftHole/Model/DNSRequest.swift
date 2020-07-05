//
//  File.swift
//  
//
//  Created by Fernando Bunn on 05/07/2020.
//

import Foundation

public struct DNSRequest {
    let date: Date
    public let adsCount: Int
    public let requestCount: Int
    
    public var startDate: Date {
         date - TimeInterval(300)
    }
    
    public var endDate: Date {
        date + TimeInterval(299)
    }
    
    public var permittedRequests: Int {
        requestCount - adsCount
    }
}
