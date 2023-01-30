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

import Foundation


/// `SemanticVersion` is a struct representing a software or project version according to ["Semantic Versioning"](https://semver.org).
///
/// Given a version number MAJOR.MINOR.PATCH, increment the:
/// 1. MAJOR version when you make incompatible API changes,
/// 2. MINOR version when you add functionality in a backwards compatible manner, and
/// PATCH version when you make backwards compatible bug fixes.
/// Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.
public struct SemanticVersion: Codable, Equatable, Hashable {
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var preRelease: String
    public var build: String

    /// Initialize a version.
    /// - Parameters:
    ///   - major: Major version number
    ///   - minor: Minor version number
    ///   - patch: Patch version number
    ///   - preRelease: Pre-release version number or details
    ///   - build: Build version number or details
    public init(_ major: Int, _ minor: Int, _ patch: Int, _ preRelease: String = "", _ build: String = "") {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease
        self.build = build
    }
}


extension SemanticVersion: LosslessStringConvertible {

    /// Initialize a version from a string. Returns `nil` if the string is not a semantic version.
    /// - Parameter string: Version string.
    public init?(_ string: String) {
        let groups = semVerRegex.matchGroups(string)
        guard
            groups.count == semVerRegex.numberOfCaptureGroups,
            let major = Int(groups[0]),
            let minor = Int(groups[1]),
            let patch = Int(groups[2])
        else { return nil }
        self = .init(major, minor, patch, groups[3], groups[4])
    }

    public var description: String {
        let pre = preRelease.isEmpty ? "" : "-" + preRelease
        let bld = build.isEmpty ? "" : "+" + build
        return "\(major).\(minor).\(patch)\(pre)\(bld)"
    }
}


extension SemanticVersion: Comparable {
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }
        if lhs.preRelease != rhs.preRelease {
            // Ensure stable versions sort after their betas ...
            if lhs.isStable { return false }
            if rhs.isStable { return true }
            // ... otherwise sort by preRelease
            return lhs.preRelease < rhs.preRelease
        }
        // ... and build
        return lhs.build < rhs.build
    }
}


extension SemanticVersion {
    public var isStable: Bool { return preRelease.isEmpty && build.isEmpty }
    public var isPreRelease: Bool { return !isStable }
    public var isMajorRelease: Bool { return isStable && (major > 0 && minor == 0 && patch == 0) }
    public var isMinorRelease: Bool { return isStable && (minor > 0 && patch == 0) }
    public var isPatchRelease: Bool { return isStable && patch > 0 }
    public var isInitialRelease: Bool { return self == .init(0, 0, 0) }
}


// Source: https://regex101.com/r/Ly7O1x/3/
// Linked from https://semver.org
#if swift(>=5)

let semVerRegex = NSRegularExpression(#"""
^
v?                              # SPI extension: allow leading 'v'
(?<major>0|[1-9]\d*)
\.
(?<minor>0|[1-9]\d*)
\.
(?<patch>0|[1-9]\d*)
(?:-
  (?<prerelease>
    (?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
    (?:\.
      (?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
    )
  *)
)?
(?:\+
  (?<buildmetadata>[0-9a-zA-Z-]+
    (?:\.[0-9a-zA-Z-]+)
  *)
)?
$
"""#, options: [.allowCommentsAndWhitespace])

#else

let semVerRegex = NSRegularExpression("""
^
v?                              # SPI extension: allow leading 'v'
(?<major>0|[1-9]\\d*)
\\.
(?<minor>0|[1-9]\\d*)
\\.
(?<patch>0|[1-9]\\d*)
(?:-
  (?<prerelease>
    (?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)
    (?:\\.
      (?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)
    )
  *)
)?
(?:\\+
  (?<buildmetadata>[0-9a-zA-Z-]+
    (?:\\.[0-9a-zA-Z-]+)
  *)
)?
$
""", options: [.allowCommentsAndWhitespace])

#endif
