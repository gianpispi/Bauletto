import XCTest
@testable import Banner

final class BannerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Banner().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
