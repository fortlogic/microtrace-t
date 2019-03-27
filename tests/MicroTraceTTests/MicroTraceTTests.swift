import XCTest
@testable import MicroTraceT

final class MicroTraceTTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MicroTraceT().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
