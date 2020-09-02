#if swift(>=5)

#else

import XCTest

@testable import SemanticVersionTests

extension SemanticVersionTests {
    static var allTests: [(String, (SemanticVersionTests) -> () throws -> Void)] = [
        ("test_semVerRegex_valid", test_semVerRegex_valid),
        ("test_allow_leading_v", test_allow_leading_v),
        ("test_semVerRegex_invalid", test_semVerRegex_invalid),
        ("test_init", test_init),
        ("test_description", test_description),
        ("test_Comparable", test_Comparable),
        ("test_isStable", test_isStable),
        ("test_isMajorRelease", test_isMajorRelease),
        ("test_isMinorRelease", test_isMinorRelease),
        ("test_isPatchRelease", test_isPatchRelease),
    ]
}

XCTMain([
    testCase(SemanticVersionTests.allTests)
])

#endif
