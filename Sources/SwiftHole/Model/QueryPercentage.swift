//
//  QueryPercentage.swift
//  
//
//  Created by Fernando Bunn on 23/05/2021.
//

import Foundation

public struct QueryPercentage {
    public enum QueryType: String, CaseIterable {
        case IPv4 = "A (IPv4)"
        case IPv6 = "AAAA (IPv6)"
        case ANY
        case SRV
        case SOA
        case PTR
        case TXT
        case NAPTR
        case MX
        case DS
        case RRSIG
        case DNSKEY
        case NS
        case OTHER
        case SVCB
        case HTTPS
    }
    
    public let value: Double
    public let type: QueryType
    
}

internal extension QueryPercentage {
    struct QueryTypes: Decodable {
        let querytypes: [String: Double]
    }
    
    struct List: Decodable {
        let values: [QueryPercentage]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let types = try container.decode(QueryTypes.self)
            
            values = types.querytypes.map { key, value in
                QueryPercentage(value: value, type: QueryType(rawValue: key) ?? .OTHER)
            }
        }
    }
}
