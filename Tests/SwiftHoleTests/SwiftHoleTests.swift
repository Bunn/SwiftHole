import XCTest
@testable import SwiftHole

final class SwiftHoleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftHole().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
