import XCTest

extension CTraceTTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CTraceTTests.__allTests),
    ]
}
#endif
