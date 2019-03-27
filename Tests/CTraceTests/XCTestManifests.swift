import XCTest

extension Vector2Tests {
    static let __allTests = [
        ("test_test", test_test),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Vector2Tests.__allTests),
    ]
}
#endif
