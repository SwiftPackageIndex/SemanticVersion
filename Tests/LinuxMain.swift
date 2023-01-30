// Copyright Dave Verwer, Sven A. Schmidt, and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
