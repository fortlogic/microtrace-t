import XCTest

extension Vector2Tests {
    static let __allTests = [
        ("test_add", test_add),
        ("test_addn", test_addn),
        ("test_distance", test_distance),
        ("test_dot", test_dot),
        ("test_magnitude", test_magnitude),
        ("test_negate", test_negate),
        ("test_normalize", test_normalize),
        ("test_scale", test_scale),
        ("test_subtract", test_subtract),
        ("test_subtractn", test_subtractn),
        ("test_unit_u", test_unit_u),
        ("test_unit_v", test_unit_v),
        ("test_zero", test_zero),
    ]
}

extension Vector3Tests {
    static let __allTests = [
        ("test_add", test_add),
        ("test_addn", test_addn),
        ("test_distance", test_distance),
        ("test_dot", test_dot),
        ("test_magnitude", test_magnitude),
        ("test_negate", test_negate),
        ("test_normalize", test_normalize),
        ("test_scale", test_scale),
        ("test_subtract", test_subtract),
        ("test_subtractn", test_subtractn),
        ("test_unit_i", test_unit_i),
        ("test_unit_j", test_unit_j),
        ("test_unit_k", test_unit_k),
        ("test_zero", test_zero),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Vector2Tests.__allTests),
        testCase(Vector3Tests.__allTests),
    ]
}
#endif
