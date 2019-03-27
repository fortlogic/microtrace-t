import XCTest

import CTraceTests
import µtraceTTests

var tests = [XCTestCaseEntry]()
tests += CTraceTests.__allTests()
tests += µtraceTTests.__allTests()

XCTMain(tests)
