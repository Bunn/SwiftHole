import XCTest
@testable import SwiftHole

final class SwiftHoleTests: XCTestCase {
    
    func testSummaryCodableVersion5x() {
        let jsonString = """
                    {
                      "domains_being_blocked": 276319,
                      "dns_queries_today": 37852,
                      "ads_blocked_today": 5356,
                      "ads_percentage_today": 14.149847,
                      "unique_domains": 6863,
                      "queries_forwarded": 23015,
                      "queries_cached": 6932,
                      "clients_ever_seen": 33,
                      "unique_clients": 19,
                      "dns_queries_all_types": 37852,
                      "reply_NODATA": 3097,
                      "reply_NXDOMAIN": 4675,
                      "reply_CNAME": 10987,
                      "reply_IP": 17593,
                      "privacy_level": 0,
                      "status": "enabled",
                      "gravity_last_updated": {
                        "file_exists": true,
                        "absolute": 1589194189,
                        "relative": {
                          "days": 5,
                          "hours": 1,
                          "minutes": 36
                        }
                      }
                    }
                    """
        
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Can't transform string into data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(Summary.self, from: data)
            XCTAssert(decoded.domainsBeingBlocked == 276319)
            XCTAssert(decoded.dnsQueriesToday == 37852)
            XCTAssert(decoded.adsBlockedToday == 5356)
            XCTAssert(decoded.adsPercentageToday == 14.149847)
            XCTAssert(decoded.uniqueDomains == 6863)
            XCTAssert(decoded.queriesForwarded == 23015)
            XCTAssert(decoded.queriesCached == 6932)
            XCTAssert(decoded.clientsEverSeen == 33)
            XCTAssert(decoded.uniqueClients == 19)
            XCTAssert(decoded.dnsQueriesAllTypes == 37852)
            XCTAssert(decoded.replyNODATA == 3097)
            XCTAssert(decoded.replyNXDOMAIN == 4675)
            XCTAssert(decoded.replyCNAME == 10987)
            XCTAssert(decoded.replyIP == 17593)
            XCTAssert(decoded.privacyLevel == 0)
            XCTAssert(decoded.status == "enabled")
            XCTAssert(decoded.gravityLastUpdated.fileExists == true)
            XCTAssert(decoded.gravityLastUpdated.absolute == 1589194189)
            XCTAssert(decoded.gravityLastUpdated.relative.days == 5)
            XCTAssert(decoded.gravityLastUpdated.relative.hours == 1)
            XCTAssert(decoded.gravityLastUpdated.relative.minutes == 36)
            
        } catch {
            XCTFail("Can't decode test file bundle \(error)")
        }
    }
    
    func testSummaryCodableVersion4x() {
        let jsonString = """
                    {
                      "domains_being_blocked": 261271,
                      "dns_queries_today": 27581,
                      "ads_blocked_today": 4295,
                      "ads_percentage_today": 15.572314,
                      "unique_domains": 2760,
                      "queries_forwarded": 19663,
                      "queries_cached": 3623,
                      "clients_ever_seen": 14,
                      "unique_clients": 13,
                      "dns_queries_all_types": 27581,
                      "reply_NODATA": 2732,
                      "reply_NXDOMAIN": 1071,
                      "reply_CNAME": 8179,
                      "reply_IP": 11865,
                      "privacy_level": 0,
                      "status": "enabled",
                      "gravity_last_updated": {
                        "file_exists": true,
                        "absolute": 1587264260,
                        "relative": {
                          "days": "0",
                          "hours": "18",
                          "minutes": "47"
                        }
                      }
                    }
                    """
        
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Can't transform string into data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(Summary.self, from: data)
            XCTAssert(decoded.domainsBeingBlocked == 261271)
            XCTAssert(decoded.dnsQueriesToday == 27581)
            XCTAssert(decoded.adsBlockedToday == 4295)
            XCTAssert(decoded.adsPercentageToday == 15.572314)
            XCTAssert(decoded.uniqueDomains == 2760)
            XCTAssert(decoded.queriesForwarded == 19663)
            XCTAssert(decoded.queriesCached == 3623)
            XCTAssert(decoded.clientsEverSeen == 14)
            XCTAssert(decoded.uniqueClients == 13)
            XCTAssert(decoded.dnsQueriesAllTypes == 27581)
            XCTAssert(decoded.replyNODATA == 2732)
            XCTAssert(decoded.replyNXDOMAIN == 1071)
            XCTAssert(decoded.replyCNAME == 8179)
            XCTAssert(decoded.replyIP == 11865)
            XCTAssert(decoded.privacyLevel == 0)
            XCTAssert(decoded.status == "enabled")
            XCTAssert(decoded.gravityLastUpdated.fileExists == true)
            XCTAssert(decoded.gravityLastUpdated.absolute == 1587264260)
            XCTAssert(decoded.gravityLastUpdated.relative.days == 0)
            XCTAssert(decoded.gravityLastUpdated.relative.hours == 18)
            XCTAssert(decoded.gravityLastUpdated.relative.minutes == 47)
            
        } catch {
            XCTFail("Can't decode test file bundle \(error)")
        }
    }
    
    static var allTests = [
        ("testSummaryCodable", testSummaryCodableVersion5x),
        ("testSummaryCodable", testSummaryCodableVersion4x),
    ]
}
