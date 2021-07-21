//
//  Summary.swift
//
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

public struct Summary: Decodable {
    public let domainsBeingBlocked, dnsQueriesToday, adsBlockedToday: Int
    public let adsPercentageToday: Double
    public let uniqueDomains, queriesForwarded, queriesCached, clientsEverSeen: Int
    public let uniqueClients, dnsQueriesAllTypes, replyNODATA, replyNXDOMAIN: Int
    public let replyCNAME, replyIP, privacyLevel: Int
    public let status: String
    public let gravityLastUpdated: GravityLastUpdated
    
    public var isEnabled: Bool {
        return status.lowercased() == "enabled"
    }

    enum CodingKeys: String, CodingKey {
        case domainsBeingBlocked = "domains_being_blocked"
        case dnsQueriesToday = "dns_queries_today"
        case adsBlockedToday = "ads_blocked_today"
        case adsPercentageToday = "ads_percentage_today"
        case uniqueDomains = "unique_domains"
        case queriesForwarded = "queries_forwarded"
        case queriesCached = "queries_cached"
        case clientsEverSeen = "clients_ever_seen"
        case uniqueClients = "unique_clients"
        case dnsQueriesAllTypes = "dns_queries_all_types"
        case replyNODATA = "reply_NODATA"
        case replyNXDOMAIN = "reply_NXDOMAIN"
        case replyCNAME = "reply_CNAME"
        case replyIP = "reply_IP"
        case privacyLevel = "privacy_level"
        case status
        case gravityLastUpdated = "gravity_last_updated"
    }
}


// MARK: - GravityLastUpdated

public struct GravityLastUpdated: Decodable {
    public let fileExists: Bool
    public let absolute: Int
    public let relative: Relative

    enum CodingKeys: String, CodingKey {
        case fileExists = "file_exists"
        case absolute, relative
    }
}


// MARK: - Relative

public struct Relative: Decodable {

    public var days, hours, minutes: Int
    
    enum CodingKeys: String, CodingKey {
          case days
          case hours
          case minutes
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        /*
         Pi-hole 4.x used Strings for these values
         whereas 5.x uses Int, so we try to decode both
         */
        do {
            days = Int(try values.decode(String.self, forKey: .days)) ?? 0
            hours = Int(try values.decode(String.self, forKey: .hours)) ?? 0
            minutes = Int(try values.decode(String.self, forKey: .minutes)) ?? 0
        } catch {
            days = try values.decode(Int.self, forKey: .days)
            hours = try values.decode(Int.self, forKey: .hours)
            minutes = try values.decode(Int.self, forKey: .minutes)
        }
    }
    
    internal init(days: Int, hours: Int, minutes: Int) {
        self.days = days
        self.hours = hours
        self.minutes = minutes
    }
    
}


extension Summary: Mockable {
    public static func mockData() -> Summary {
        Summary(domainsBeingBlocked: 100, dnsQueriesToday: 2, adsBlockedToday: 3, adsPercentageToday: 4, uniqueDomains: 5, queriesForwarded: 6, queriesCached: 7, clientsEverSeen: 8, uniqueClients: 9, dnsQueriesAllTypes: 10, replyNODATA: 11, replyNXDOMAIN: 12, replyCNAME: 13, replyIP: 14, privacyLevel: 15, status: "enabled", gravityLastUpdated: GravityLastUpdated.mockData())
    }
}

extension GravityLastUpdated: Mockable {
    public static func mockData() -> GravityLastUpdated {
        GravityLastUpdated(fileExists: true, absolute: 1, relative: Relative.mockData())
    }
}

extension Relative: Mockable {
    public static func mockData() -> Relative {
        Relative(days: 10, hours: 11, minutes: 12)
    }
}
