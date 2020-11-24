import XCTest
@testable import SwiftHole


/*
 If you want to run tests on a real pi-hole you need to setup the PiholeHost bellow
 ps. I did not forget to remove my host/token, they are from a Virtual Machine I use only for testing this library, but thanks for caring :)
 */
let shouldRunRealPiholeTests = false
let testExpectationTimeout: TimeInterval = 10

private struct PiholeHost {
    let host = "192.168.56.101"
    let token = "4a5c00a194743937ca021bda9bbbd82791cc62b72b6ce47d4a9bcf24c12e6576"
    let secure = false
    let timeout: TimeInterval = 10
}

final class SwiftHoleTests: XCTestCase {
    
  
    //MARK:- Remote Tests
    
    func testRemoveItemFromBlackList() throws {
        try validateRemoteTests()

        let host = PiholeHost()
        let domain = "www.mynewdomain.com"
        
        let expectation = XCTestExpectation(description: "Remove domain from blacklist")
        let service = SwiftHole(host: host.host, apiToken: host.token, timeoutInterval: host.timeout, secure: host.secure)
        service.add(domain: domain, to: .blacklist) { result in
            
            self.checkIfDomainExists(domain, on: .blacklist) { result in
                XCTAssert(result, "Domain should exist")

                service.remove(domain: domain, from: .blacklist) { result in
                    switch result {
                    case .success:
                        self.checkIfDomainExists(domain, on: .blacklist) { result in
                            XCTAssert(result == false, "Domain should not exist")
                        }
                    case .failure(let error):
                        XCTFail("Async list error \(error)")
                    }
                    expectation.fulfill()
                }
            }
        }
        
        service.remove(domain: "www.customdomain.com", from: .blacklist) { result in
            switch result {
            case .success:
                break;
            case .failure(let error):
                XCTFail("Async list error \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: testExpectationTimeout)
    }

    func testAddInvalidItemToBlacklist() throws {
        try validateRemoteTests()

        let host = PiholeHost()
        let expectation = XCTestExpectation(description: "Add invalid URL to blacklist")
        let service = SwiftHole(host: host.host, apiToken: host.token, timeoutInterval: host.timeout, secure: host.secure)

        service.add(domain: "www.###.com", to: .blacklist) { result in
            switch result {
            case .success:
                XCTFail("It should not work")
            case .failure(let error):
                switch error {
                case .cantAddNewListItem:
                    break
                default:
                    XCTFail("Async list error \(error)")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: testExpectationTimeout)
    }
    
    func testAddItemToBlacklist() throws {
        try validateRemoteTests()

        let host = PiholeHost()
        let expectation = XCTestExpectation(description: "Add URL to blacklist")
        let service = SwiftHole(host: host.host, apiToken: host.token, timeoutInterval: host.timeout, secure: host.secure)
        let domain = "www.customdomain.com"
        
        service.add(domain: domain, to: .blacklist) { result in
            switch result {
            case .success:
                self.checkIfDomainExists(domain, on: .blacklist) { result in
                    XCTAssert(result, "Domain should exist")
                }
                break
            case .failure(let error):
                switch error {
                case .cantAddNewListItem(let message):
                    XCTFail("Async list error \(message)")
                default:
                    XCTFail("Async list error \(error)")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: testExpectationTimeout)
    }
    
    func testFetchRemoteWhitelist() throws {
        try validateRemoteTests()

        let host = PiholeHost()
        
        let expectation = XCTestExpectation(description: "Download whitelist data")
        let service = SwiftHole(host: host.host, apiToken: host.token, timeoutInterval: host.timeout, secure: host.secure)
        
        service.fetchList(.whitelist) { result in
            switch result {
            case .success(let list):
                XCTAssertNotNil(list)

                list.forEach { item in
                    XCTAssertEqual(item.listType, .whitelist)
                }
            case .failure(let error):
                XCTFail("Async list error \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: testExpectationTimeout)
    }
    
    func testFetchRemoteBlacklist() throws {
        try validateRemoteTests()

        let host = PiholeHost()
        
        let expectation = XCTestExpectation(description: "Download blacklist data")
        let service = SwiftHole(host: host.host, apiToken: host.token, timeoutInterval: host.timeout, secure: host.secure)
        
        service.fetchList(.blacklist) { result in
            switch result {
            case .success(let list):
                XCTAssertNotNil(list)

                list.forEach { item in
                    XCTAssertEqual(item.listType, .blacklist)
                }
            case .failure(let error):
                XCTFail("Async list error \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: testExpectationTimeout)
    }
    
    
    //MARK:- Local Tests
    
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
            XCTAssertEqual(decoded.domainsBeingBlocked, 276319, "it should have 276319 domainsBeingBlocked")
            XCTAssertEqual(decoded.dnsQueriesToday, 37852, "it should have 37852 dnsQueriesToday")
            XCTAssertEqual(decoded.adsBlockedToday, 5356, "it should have 5356 adsBlockedToday")
            XCTAssertEqual(decoded.adsPercentageToday, 14.149847, "it should have 14.149847 adsPercentageToday")
            XCTAssertEqual(decoded.uniqueDomains, 6863, "it should have 6863 uniqueDomains")
            XCTAssertEqual(decoded.queriesForwarded, 23015, "it should have 23015 queriesForwarded")
            XCTAssertEqual(decoded.queriesCached, 6932, "it should have 6932 queriesCached")
            XCTAssertEqual(decoded.clientsEverSeen, 33, "it should have 33 clientsEverSeen")
            XCTAssertEqual(decoded.uniqueClients, 19, "it should have 19 uniqueClients")
            XCTAssertEqual(decoded.dnsQueriesAllTypes, 37852, "it should have 37852 dnsQueriesAllTypes")
            XCTAssertEqual(decoded.replyNODATA, 3097, "it should have 3097 replyNODATA")
            XCTAssertEqual(decoded.replyNXDOMAIN, 4675, "it should have 4675 replyNXDOMAIN")
            XCTAssertEqual(decoded.replyCNAME, 10987, "it should have 10987 replyCNAME")
            XCTAssertEqual(decoded.replyIP, 17593, "it should have 17593 replyIP")
            XCTAssertEqual(decoded.privacyLevel, 0, "it should have 0 privacyLevel")
            XCTAssertEqual(decoded.status, "enabled", "it should have status enabled")
            XCTAssertEqual(decoded.gravityLastUpdated.fileExists, true, "it should have fileExists true")
            XCTAssertEqual(decoded.gravityLastUpdated.absolute, 1589194189, "it should have 1589194189 gravityLastUpdated.absolute")
            XCTAssertEqual(decoded.gravityLastUpdated.relative.days, 5, "it should have 5 gravityLastUpdated.relative.days")
            XCTAssertEqual(decoded.gravityLastUpdated.relative.hours, 1, "it should have 1 gravityLastUpdated.relative.hours")
            XCTAssertEqual(decoded.gravityLastUpdated.relative.minutes, 36, "it should have 36 gravityLastUpdated.relative.minutes")
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
            XCTAssertEqual(decoded.domainsBeingBlocked, 261271, "it should have 261271 domainsBeingBlocked")
            XCTAssertEqual(decoded.dnsQueriesToday, 27581, "it should have 27581 dnsQueriesToday")
            XCTAssertEqual(decoded.adsBlockedToday, 4295, "it should have 4295 adsBlockedToday")
            XCTAssertEqual(decoded.adsPercentageToday, 15.572314, "it should have 15.572314 adsPercentageToday")
            XCTAssertEqual(decoded.uniqueDomains, 2760, "it should have 2760 uniqueDomains")
            XCTAssertEqual(decoded.queriesForwarded, 19663, "it should have 19663 queriesForwarded")
            XCTAssertEqual(decoded.queriesCached, 3623, "it should have 3623 queriesCached")
            XCTAssertEqual(decoded.clientsEverSeen, 14, "it should have 14 clientsEverSeen")
            XCTAssertEqual(decoded.uniqueClients, 13, "it should have 13 uniqueClients")
            XCTAssertEqual(decoded.dnsQueriesAllTypes, 27581, "it should have 261271 dnsQueriesAllTypes")
            XCTAssertEqual(decoded.replyNODATA, 2732, "it should have 261271 replyNODATA")
            XCTAssertEqual(decoded.replyNXDOMAIN, 1071, "it should have 1071 replyNXDOMAIN")
            XCTAssertEqual(decoded.replyCNAME, 8179, "it should have 8179 replyCNAME")
            XCTAssertEqual(decoded.replyIP, 11865, "it should have 11865 replyIP")
            XCTAssertEqual(decoded.privacyLevel, 0, "it should have 0 privacyLevel")
            XCTAssertEqual(decoded.status, "enabled", "it should have status enabled")
            XCTAssertEqual(decoded.gravityLastUpdated.fileExists, true, "it should have fileExists true")
            XCTAssertEqual(decoded.gravityLastUpdated.absolute, 1587264260, "it should have 1587264260 gravityLastUpdated.absolute")
            XCTAssertEqual(decoded.gravityLastUpdated.relative.days, 0, "it should have 0 gravityLastUpdated.relative.days")
            XCTAssertEqual(decoded.gravityLastUpdated.relative.hours, 18, "it should have 18 gravityLastUpdated.relative.hours")
            XCTAssertEqual(decoded.gravityLastUpdated.relative.minutes, 47, "it should have 47 gravityLastUpdated.relative.minutes")
        } catch {
            XCTFail("Can't decode test file bundle \(error)")
        }
    }
    
    func testDomainsOverTime() {
        let jsonString = """
        {
          "domains_over_time": {
            "1593882300": 357,
            "1593882900": 209,
            "1593883500": 211,
            "1593884100": 170,
            "1593884700": 274,
            "1593885300": 224,
            "1593885900": 368,
            "1593886500": 238,
            "1593887100": 652,
            "1593887700": 392,
            "1593888300": 331,
            "1593888900": 279
          },
          "ads_over_time": {
            "1593882300": 104,
            "1593882900": 60,
            "1593883500": 34,
            "1593884100": 30,
            "1593884700": 117,
            "1593885300": 71,
            "1593885900": 44,
            "1593886500": 51,
            "1593887100": 83,
            "1593887700": 54,
            "1593888300": 54,
            "1593888900": 70
          }
        }
    """
        
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Can't transform string into data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(HistoricalQueries.self, from: data)
            XCTAssertEqual(decoded.requests.count, 12, "it should have 12 requests")
            
            XCTAssertEqual(decoded.requests[0].adsCount, 104, "it should have 104 ads")
            XCTAssertEqual(decoded.requests[0].permittedRequests, 253, "it should have 253 permitted requests")
            XCTAssertEqual(decoded.requests[0].requestCount, 357, "it should have 253 permitted requests")
            XCTAssertEqual(decoded.requests[0].date.timeIntervalSince1970, TimeInterval(1593882300), "date should be 1593882300 timeInterval")
            XCTAssertEqual(decoded.requests[0].startDate.timeIntervalSince1970, TimeInterval((1593882000)), "startDate should be 1593882000 timeInterval")
            XCTAssertEqual(decoded.requests[0].endDate.timeIntervalSince1970, TimeInterval(1593882599), "startDate should be 1593882000 timeInterval")
            
            XCTAssertEqual(decoded.requests[5].adsCount, 71, "it should have 71 ads")
            XCTAssertEqual(decoded.requests[5].permittedRequests, 153, "it should have 153 permitted requests")
            XCTAssertEqual(decoded.requests[5].requestCount, 224, "it should have 224 permitted requests")
            XCTAssertEqual(decoded.requests[5].date.timeIntervalSince1970, TimeInterval(1593885300), "date should be 1593885300 timeInterval")
            XCTAssertEqual(decoded.requests[5].startDate.timeIntervalSince1970, TimeInterval((1593885000)), "startDate should be 1593885000 timeInterval")
            XCTAssertEqual(decoded.requests[5].endDate.timeIntervalSince1970, TimeInterval(1593885599), "startDate should be 1593885599 timeInterval")
        } catch {
            XCTFail("Can't decode test file bundle \(error)")
        }
    }
    
    static var allTests = [
        ("testSummaryCodable", testSummaryCodableVersion5x),
        ("testSummaryCodable", testSummaryCodableVersion4x),
    ]
}


extension SwiftHoleTests {
    
    private func checkIfDomainExists(_ domain: String, on list: ListType, completion: @escaping (Bool) -> () ) {
        let host = PiholeHost()
        let service = SwiftHole(host: host.host, apiToken: host.token, timeoutInterval: host.timeout, secure: host.secure)

        service.fetchList(list) { result in
            switch result {
            case .success(let list):
                let result = list.filter { $0.domain == domain }
                completion(result.count > 0)
            case .failure:
                completion(false)
            }
        }
    }
    
    private func validateRemoteTests() throws {
        try XCTSkipIf(shouldRunRealPiholeTests == false, "Should not run real pi-hole tests")
    }
}
