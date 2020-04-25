//
//  File.swift
//  
//
//  Created by Fernando Bunn on 25/04/2020.
//

import Foundation

public struct Summary: Codable {
    let domainsBeingBlocked, dnsQueriesToday, adsBlockedToday: Int
    let adsPercentageToday: Double
    let uniqueDomains, queriesForwarded, queriesCached, clientsEverSeen: Int
    let uniqueClients, dnsQueriesAllTypes, replyNODATA, replyNXDOMAIN: Int
    let replyCNAME, replyIP, privacyLevel: Int
    let status: String
    let gravityLastUpdated: GravityLastUpdated

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

public struct GravityLastUpdated: Codable {
    let fileExists: Bool
    let absolute: Int
    let relative: Relative

    enum CodingKeys: String, CodingKey {
        case fileExists = "file_exists"
        case absolute, relative
    }
}


// MARK: - Relative

public struct Relative: Codable {
    let days, hours, minutes: String
}
