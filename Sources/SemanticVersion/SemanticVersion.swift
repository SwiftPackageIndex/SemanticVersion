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
public struct SemanticVersion: Equatable, Hashable {
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

    public enum PreReleaseIdentifier: Equatable {
        case alphanumeric(String)
        case numeric(Int)
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

        // A stable release takes precedence over a pre-release
        if lhs.isStable != rhs.isStable { return rhs.isStable }

        // Otherwise compare the pre-releases per section 11.4
        // See: https://semver.org/#spec-item-11
        return lhs.preReleaseIdentifiers < rhs.preReleaseIdentifiers

        // Note that per section 10, buildmetadata MUST not be
        // considered when determining precedence
        // See: https://semver.org/#spec-item-10
    }
}


extension SemanticVersion {
    public var isStable: Bool { return preRelease.isEmpty }
    public var isPreRelease: Bool { return !isStable }
    public var isMajorRelease: Bool { return isStable && (major > 0 && minor == 0 && patch == 0) }
    public var isMinorRelease: Bool { return isStable && (minor > 0 && patch == 0) }
    public var isPatchRelease: Bool { return isStable && patch > 0 }
    public var isInitialRelease: Bool { return self == .init(0, 0, 0) }

    public var preReleaseIdentifiers: [PreReleaseIdentifier] {
        return preRelease
            .split(separator: ".")
            .map { PreReleaseIdentifier(String($0)) }
    }
}

extension SemanticVersion.PreReleaseIdentifier {
    init(_ rawValue: String) {
        if let number = Int(rawValue) {
            self = .numeric(number)
        } else {
            self = .alphanumeric(rawValue)
        }
    }
}

extension SemanticVersion.PreReleaseIdentifier: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        // These rules are laid out in section 11.4 of the semver spec
        // See: https://semver.org/#spec-item-11
        switch (lhs, rhs) {
        case (.numeric, .alphanumeric):
            // 11.4.3 - Numeric identifiers always have lower precedence than non-numeric identifiers
            return true
        case (.alphanumeric, .numeric):
            // 11.4.3 - Numeric identifiers always have lower precedence than non-numeric identifiers
            return false
        case (.numeric(let lhInt), .numeric(let rhInt)):
            // 11.4.1 - Identifiers consisting of only digits are compared numerically
            return lhInt < rhInt
        case (.alphanumeric(let lhString), .alphanumeric(let rhString)):
            // 11.4.2 - Identifiers with letters or hyphens are compared lexically in ASCII sort order
            return lhString < rhString
        }
    }
}


extension Array: Comparable where Element == SemanticVersion.PreReleaseIdentifier {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        // Per section 11.4 of the semver spec, compare left to right until a
        // difference is found.
        // See: https://semver.org/#spec-item-11
        for (lhIdentifier, rhIdentifier) in zip(lhs, rhs) {
            if lhIdentifier != rhIdentifier { return lhIdentifier < rhIdentifier }
        }

        // 11.4.4 - A larger set of identifiers will have a higher precendence
        // than a smaller set, if all the preceding identifiers are equal.
        return lhs.count < rhs.count
    }
}

#if swift(>=5.5)
extension SemanticVersion: Sendable {}
#endif


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
