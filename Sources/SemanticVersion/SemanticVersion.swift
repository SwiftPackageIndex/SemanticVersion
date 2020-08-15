import Foundation


public struct SemanticVersion: Codable, Equatable, Hashable {
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var preRelease: String
    public var build: String

    public init(_ major: Int, _ minor: Int, _ patch: Int, _ preRelease: String = "", _ build: String = "") {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease
        self.build = build
    }
}


extension SemanticVersion: LosslessStringConvertible {
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
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }
        // Not entirely sure how much sense it makes to compare the pre and build values
        // but it's probably better than just ignoring them
        if lhs.preRelease != rhs.preRelease { return lhs.preRelease < rhs.preRelease }
        return lhs.build < rhs.build
    }
}


extension SemanticVersion {
    public var isStable: Bool { preRelease.isEmpty && build.isEmpty }
    public var isPreRelease: Bool { !isStable }
    public var isMajorRelease: Bool { isStable && (major > 0 && minor == 0 && patch == 0) }
    public var isMinorRelease: Bool { isStable && (minor > 0 && patch == 0) }
    public var isPatchRelease: Bool { isStable && patch > 0 }
    public var isInitialRelease: Bool { self == .init(0, 0, 0) }
}


// Source: https://regex101.com/r/Ly7O1x/3/
// Linked from https://semver.org
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
