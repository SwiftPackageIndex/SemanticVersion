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


extension SemanticVersion: LosslessStringConvertible {

    /// Initialize a version from a string. Returns `nil` if the string is not a semantic version.
    /// - Parameter string: Version string.
    public init?(_ string: String) {
        guard let match = string.wholeMatch(of: semVerRegex) else { return nil }
        guard
            let major = Int(match.major),
            let minor = Int(match.minor),
            let patch = Int(match.patch)
        else { return nil }
        self = .init(major, minor, patch,
                     match.prerelease.map(String.init) ?? "",
                     match.buildmetadata.map(String.init) ?? "")
    }

    public var description: String {
        let pre = preRelease.isEmpty ? "" : "-" + preRelease
        let bld = build.isEmpty ? "" : "+" + build
        return "\(major).\(minor).\(patch)\(pre)\(bld)"
    }
}


// Source: https://regex101.com/r/Ly7O1x/3/
// Linked from https://semver.org
let semVerRegex = #/
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
    /#
