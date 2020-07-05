//
//  HistoricalData.swift
//  
//
//  Created by Fernando Bunn on 05/07/2020.
//

import Foundation

public struct HistoricalQueries: Decodable {
    let domainsOverTime, adsOverTime: [String: Int]
    let requests: [DNSRequest]

    enum CodingKeys: String, CodingKey {
        case domainsOverTime = "domains_over_time"
        case adsOverTime = "ads_over_time"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        domainsOverTime = try values.decode([String: Int].self, forKey: .domainsOverTime)
        let ads = try values.decode([String: Int].self, forKey: .adsOverTime)
        
        requests = domainsOverTime.map { key, value in
            let date = Date(timeIntervalSince1970: Double(key) ?? 0)
            return DNSRequest(date: date, adsCount: ads[key] ?? 0, requestCount: value)
        }.sorted(by: { $0.date < $1.date })
        adsOverTime = ads
    }
}
