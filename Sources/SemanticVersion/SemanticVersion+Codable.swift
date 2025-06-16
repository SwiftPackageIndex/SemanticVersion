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

#if canImport(Foundation)

import Foundation

public enum SemanticVersionStrategy {
    /// Encode/decode the `SemanticVersion` as a structure to/from a JSON object
    case defaultCodable
    /// Encode/decode the `SemanticVersion` to/fromfrom a string that conforms to the
    /// semantic version 2.0 specification at https://semver.org.
    case semverString
}

extension JSONEncoder {
    /// The strategy to use in decoding semantic versions. Defaults to `.defaultCodable`.
    public var semanticVersionEncodingStrategy: SemanticVersionStrategy {
        get { userInfo.semanticDecodingStrategy }
        set { userInfo.semanticDecodingStrategy = newValue }
    }
}

extension JSONDecoder {
    /// The strategy to use in decoding semantic versions. Defaults to `.semverString`.
    public var semanticVersionDecodingStrategy: SemanticVersionStrategy {
        get { userInfo.semanticDecodingStrategy }
        set { userInfo.semanticDecodingStrategy = newValue }
    }
}

private extension Dictionary where Key == CodingUserInfoKey, Value == Any {
    var semanticDecodingStrategy: SemanticVersionStrategy {
        get {
            (self[.semanticVersionStrategy] as? SemanticVersionStrategy) ?? .defaultCodable
        }
        set {
            self[.semanticVersionStrategy] = newValue
        }
    }
}

private extension CodingUserInfoKey {
    static let semanticVersionStrategy = Self(rawValue: "SemanticVersionEncodingStrategy")!
}

extension SemanticVersion: Codable {
    enum CodingKeys: CodingKey {
        case major
        case minor
        case patch
        case preRelease
        case build
    }

    public init(from decoder: Decoder) throws {
        switch decoder.userInfo.semanticDecodingStrategy {
        case .defaultCodable:
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.major = try container.decode(Int.self, forKey: .major)
            self.minor = try container.decode(Int.self, forKey: .minor)
            self.patch = try container.decode(Int.self, forKey: .patch)
            self.preRelease = try container.decode(String.self, forKey: .preRelease)
            self.build = try container.decode(String.self, forKey: .build)
        case .semverString:
            let container = try decoder.singleValueContainer()
            guard let version = SemanticVersion(try container.decode(String.self)) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Expected valid semver 2.0 string"
                    )
                )
            }
            self = version
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch encoder.userInfo.semanticDecodingStrategy {
        case .defaultCodable:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(major, forKey: .major)
            try container.encode(minor, forKey: .minor)
            try container.encode(patch, forKey: .patch)
            try container.encode(preRelease, forKey: .preRelease)
            try container.encode(build, forKey: .build)
        case .semverString:
            var container = encoder.singleValueContainer()
            try container.encode(description)
        }
    }
}

#endif
