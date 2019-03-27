import XCTest

extension µtraceTTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(µtraceTTests.__allTests),
    ]
}
#endif
