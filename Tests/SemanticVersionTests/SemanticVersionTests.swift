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

import XCTest
@testable import SemanticVersion

final class SemanticVersionTests: XCTestCase {

    func test_semVerPattern_valid() throws {
        XCTAssertNotNil("0.0.4".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("0.0.4".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.2.3".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("10.20.30".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.1.2-prerelease+meta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.1.2+meta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.1.2+meta-valid".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-beta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha.beta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha.beta.1".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha.1".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha0.valid".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha.0valid".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-rc.1+build.1".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("2.0.0-rc.1+build.123".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.2.3-beta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("10.2.3-DEV-SNAPSHOT".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.2.3-SNAPSHOT-123".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("2.0.0".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.1.7".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("2.0.0+build.1848".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("2.0.1-alpha.1227".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-alpha+beta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.2.3----RC-SNAPSHOT.12.9.1--.12+788".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.2.3----R-S.12.9.1--.12+meta".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.2.3----RC-SNAPSHOT.12.9.1--.12".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0+0.build.1-rc.10000aaa-kk-0.1".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("99999999999999999999999.999999999999999999.99999999999999999".wholeMatch(of: semVerPattern))
        XCTAssertNotNil("1.0.0-0A.is.legal".wholeMatch(of: semVerPattern))
    }

    func test_allow_leading_v() throws {
        XCTAssert("v0.0.4".contains(semVerPattern))
    }

    func test_semVerPattern_invalid() throws {
        XCTAssertFalse("1".contains(semVerPattern))
        XCTAssertFalse("1.2".contains(semVerPattern))
        XCTAssertFalse("1.2.3-0123".contains(semVerPattern))
        XCTAssertFalse("1.2.3-0123.0123".contains(semVerPattern))
        XCTAssertFalse("1.1.2+.123".contains(semVerPattern))
        XCTAssertFalse("+invalid".contains(semVerPattern))
        XCTAssertFalse("-invalid".contains(semVerPattern))
        XCTAssertFalse("-invalid+invalid".contains(semVerPattern))
        XCTAssertFalse("-invalid.01".contains(semVerPattern))
        XCTAssertFalse("alpha".contains(semVerPattern))
        XCTAssertFalse("alpha.beta".contains(semVerPattern))
        XCTAssertFalse("alpha.beta.1".contains(semVerPattern))
        XCTAssertFalse("alpha.1".contains(semVerPattern))
        XCTAssertFalse("alpha+beta".contains(semVerPattern))
        XCTAssertFalse("alpha_beta".contains(semVerPattern))
        XCTAssertFalse("alpha.".contains(semVerPattern))
        XCTAssertFalse("alpha..".contains(semVerPattern))
        XCTAssertFalse("beta".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha_beta".contains(semVerPattern))
        XCTAssertFalse("-alpha.".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha..".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha..1".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha...1".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha....1".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha.....1".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha......1".contains(semVerPattern))
        XCTAssertFalse("1.0.0-alpha.......1".contains(semVerPattern))
        XCTAssertFalse("01.1.1".contains(semVerPattern))
        XCTAssertFalse("1.01.1".contains(semVerPattern))
        XCTAssertFalse("1.1.01".contains(semVerPattern))
        XCTAssertFalse("1.2".contains(semVerPattern))
        XCTAssertFalse("1.2.3.DEV".contains(semVerPattern))
        XCTAssertFalse("1.2-SNAPSHOT".contains(semVerPattern))
        XCTAssertFalse("1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788".contains(semVerPattern))
        XCTAssertFalse("1.2-RC-SNAPSHOT".contains(semVerPattern))
        XCTAssertFalse("-1.0.3-gamma+b7718".contains(semVerPattern))
        XCTAssertFalse("+justmeta".contains(semVerPattern))
        XCTAssertFalse("9.8.7+meta+meta".contains(semVerPattern))
        XCTAssertFalse("9.8.7-whatever+meta+meta".contains(semVerPattern))
    }

    func test_init() throws {
        XCTAssertEqual(SemanticVersion("1.2.3"), SemanticVersion(1, 2, 3))
        XCTAssertEqual(SemanticVersion("v1.2.3"), SemanticVersion(1, 2, 3))
        XCTAssertEqual(SemanticVersion("1.2.3-rc"), SemanticVersion(1, 2, 3, "rc"))
        XCTAssertEqual(SemanticVersion("v1.2.3-beta1"), SemanticVersion(1, 2, 3, "beta1"))
        XCTAssertEqual(SemanticVersion("v1.2.3-beta1+build5"), SemanticVersion(1, 2, 3, "beta1", "build5"))
        XCTAssertEqual(SemanticVersion("1.2.3-beta-foo"), SemanticVersion(1, 2, 3, "beta-foo"))
        XCTAssertEqual(SemanticVersion("1.2.3-beta-foo+build-42"), SemanticVersion(1, 2, 3, "beta-foo", "build-42"))
        XCTAssertEqual(SemanticVersion(""), nil)
        XCTAssertEqual(SemanticVersion("1"), nil)
        XCTAssertEqual(SemanticVersion("1.2"), nil)
        XCTAssertEqual(SemanticVersion("1.2.3rc"), nil)
        XCTAssertEqual(SemanticVersion("swift-2.2-SNAPSHOT-2016-01-11-a"), nil)
    }

    func test_description() throws {
        XCTAssertEqual(SemanticVersion("1.2.3")?.description, "1.2.3")
        XCTAssertEqual(SemanticVersion("v1.2.3")?.description, "1.2.3")
        XCTAssertEqual(SemanticVersion("1.2.3-beta1")?.description, "1.2.3-beta1")
        XCTAssertEqual(SemanticVersion("1.2.3-beta1+build")?.description, "1.2.3-beta1+build")
    }

    func test_Comparable() throws {
        XCTAssert(SemanticVersion(1, 0, 0) < SemanticVersion(2, 0, 0))
        XCTAssert(SemanticVersion(1, 0, 0) < SemanticVersion(1, 1, 0))
        XCTAssert(SemanticVersion(1, 0, 0) < SemanticVersion(1, 0, 1))
        XCTAssert(SemanticVersion(1, 0, 0, "a") < SemanticVersion(1, 0, 0, "b"))
        XCTAssertFalse(SemanticVersion(1, 0, 0, "a", "a") < SemanticVersion(1, 0, 0, "a", "b"))

        // ensure betas come before releases
        XCTAssert(SemanticVersion(1, 0, 0, "b1") < SemanticVersion(1, 0, 0))
        XCTAssertFalse(SemanticVersion(1, 0, 0, "b1") > SemanticVersion(1, 0, 0))
        // but only if major/minor/patch are the same
        XCTAssert(SemanticVersion(1, 0, 0) < SemanticVersion(1, 0, 1, "b1"))
        // once the patch bumps up to the beta level again, it sorts higher
        XCTAssert(SemanticVersion(1, 0, 1) > SemanticVersion(1, 0, 1, "b1"))

        // Ensure a release with build metadata sorts above a pre-release
        XCTAssert(SemanticVersion(1, 0, 1, "alpha") < SemanticVersion(1, 0, 1, "", "build.14"))
    }

    func test_isStable() throws {
        XCTAssert(SemanticVersion(1, 0, 0).isStable)
        XCTAssert(SemanticVersion(1, 0, 0, "").isStable)
        XCTAssert(SemanticVersion(1, 0, 0, "", "").isStable)
        XCTAssertFalse(SemanticVersion(1, 0, 0, "a").isStable)
        XCTAssertTrue(SemanticVersion(1, 0, 0, "", "a").isStable)
    }

    func test_isMajorRelease() throws {
        XCTAssertTrue(SemanticVersion(1, 0, 0).isMajorRelease)
        XCTAssertFalse(SemanticVersion(1, 0, 0, "b").isMajorRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 1).isMajorRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 1, "b").isMajorRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 0).isMajorRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 0, "b").isMajorRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 1).isMajorRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 0).isMajorRelease)
    }

    func test_isMinorRelease() throws {
        XCTAssertFalse(SemanticVersion(1, 0, 0).isMinorRelease)
        XCTAssertFalse(SemanticVersion(1, 0, 0, "b").isMinorRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 1).isMinorRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 1, "b").isMinorRelease)
        XCTAssertTrue(SemanticVersion(0, 1, 0).isMinorRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 0, "b").isMinorRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 1).isMinorRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 0).isMinorRelease)
    }

    func test_isPatchRelease() throws {
        XCTAssertFalse(SemanticVersion(1, 0, 0).isPatchRelease)
        XCTAssertFalse(SemanticVersion(1, 0, 0, "b").isPatchRelease)
        XCTAssertTrue(SemanticVersion(0, 0, 1).isPatchRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 1, "b").isPatchRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 0).isPatchRelease)
        XCTAssertFalse(SemanticVersion(0, 1, 0, "b").isPatchRelease)
        XCTAssertTrue(SemanticVersion(0, 1, 1).isPatchRelease)
        XCTAssertFalse(SemanticVersion(0, 0, 0).isPatchRelease)
    }
}
