//
//  File.swift
//  
//
//  Created by Fernando Bunn on 05/07/2020.
//

import Foundation

public struct DNSRequest {
    let date: Date
    let adsCount: Int
    let requestCount: Int
    
    var startDate: Date {
         date - TimeInterval(300)
    }
    
    var endDate: Date {
        date + TimeInterval(299)
    }
    
    var permittedRequests: Int {
        requestCount - adsCount
    }
}
