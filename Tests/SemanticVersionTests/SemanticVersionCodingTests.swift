//
//  SemanticVersionCodingTests.swift
//  
//
//  Created by Chris Eplett on 11/3/23.
//

import XCTest

import SemanticVersion

final class SemanticVersionCodingTests: XCTestCase {
    func test_semverString_is_default() throws {
        XCTAssertEqual(.semverString, JSONEncoder().semanticVersionEncodingStrategy)
        XCTAssertEqual(.semverString, JSONDecoder().semanticVersionDecodingStrategy)
    }

    func test_encodable_semverString() throws {
        let encoder = JSONEncoder()
        var actual: String

        encoder.semanticVersionEncodingStrategy = .semverString

        actual = String(data: try encoder.encode(SemanticVersion(1, 2, 3)), encoding: .utf8)!
        XCTAssertEqual(actual, #""1.2.3""#)

        actual = String(data: try encoder.encode(SemanticVersion(3, 2, 1, "alpha.4")), encoding: .utf8)!
        XCTAssertEqual(actual, #""3.2.1-alpha.4""#)

        actual = String(data: try encoder.encode(SemanticVersion(3, 2, 1, "", "build.42")), encoding: .utf8)!
        XCTAssertEqual(actual, #""3.2.1+build.42""#)

        actual = String(data: try encoder.encode(SemanticVersion(7, 7, 7, "beta.423", "build.17")), encoding: .utf8)!
        XCTAssertEqual(actual, #""7.7.7-beta.423+build.17""#)
    }

    func test_encodable_memberwise() throws {
        let encoder = JSONEncoder()
        var actual: String

        encoder.semanticVersionEncodingStrategy = .memberwise

        actual = String(data: try encoder.encode(SemanticVersion(1, 2, 3)), encoding: .utf8)!
        XCTAssertTrue(actual.contains(#""major":1"#))
        XCTAssertTrue(actual.contains(#""minor":2"#))
        XCTAssertTrue(actual.contains(#""patch":3"#))
        XCTAssertTrue(actual.contains(#""preRelease":"""#))
        XCTAssertTrue(actual.contains(#""build":"""#))

        actual = String(data: try encoder.encode(SemanticVersion(3, 2, 1, "alpha.4")), encoding: .utf8)!
        XCTAssertTrue(actual.contains(#""major":3"#))
        XCTAssertTrue(actual.contains(#""minor":2"#))
        XCTAssertTrue(actual.contains(#""patch":1"#))
        XCTAssertTrue(actual.contains(#""preRelease":"alpha.4""#))
        XCTAssertTrue(actual.contains(#""build":"""#))

        actual = String(data: try encoder.encode(SemanticVersion(3, 2, 1, "", "build.42")), encoding: .utf8)!
        XCTAssertTrue(actual.contains(#""major":3"#))
        XCTAssertTrue(actual.contains(#""minor":2"#))
        XCTAssertTrue(actual.contains(#""patch":1"#))
        XCTAssertTrue(actual.contains(#""preRelease":"""#))
        XCTAssertTrue(actual.contains(#""build":"build.42""#))

        actual = String(data: try encoder.encode(SemanticVersion(7, 7, 7, "beta.423", "build.17")), encoding: .utf8)!
        XCTAssertTrue(actual.contains(#""major":7"#))
        XCTAssertTrue(actual.contains(#""minor":7"#))
        XCTAssertTrue(actual.contains(#""patch":7"#))
        XCTAssertTrue(actual.contains(#""preRelease":"beta.423""#))
        XCTAssertTrue(actual.contains(#""build":"build.17""#))
    }

    func test_decodable_semverString() throws {
        let decoder = JSONDecoder()
        var json: Data

        decoder.semanticVersionDecodingStrategy = .semverString

        json = #""1.2.3-a.4+42.7""#.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(SemanticVersion.self, from: json),
            SemanticVersion(1, 2, 3, "a.4", "42.7")
        )

        json = #"["1.2.3-a.4+42.7", "7.7.7"]"#.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode([SemanticVersion].self, from: json),
            [SemanticVersion(1, 2, 3, "a.4", "42.7"), SemanticVersion(7, 7, 7)]
        )

        struct Foo: Decodable, Equatable {
            let v: SemanticVersion
        }

        json = #"{"v": "1.2.3-a.4+42.7"}"#.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Foo.self, from: json),
            Foo(v: SemanticVersion(1, 2, 3, "a.4", "42.7"))
        )

        json = #"{"v": "I AM NOT A SEMVER"}"#.data(using: .utf8)!
        XCTAssertThrowsError(_ = try decoder.decode(Foo.self, from: json)) { error in
            switch error as? DecodingError {
            case .dataCorrupted(let context):
                XCTAssertEqual(context.codingPath.map(\.stringValue), ["v"])
                XCTAssertEqual(context.debugDescription, "Expected valid semver 2.0 string")
            default:
                XCTFail("Expected DecodingError.dataCorrupted, got \(error)")
            }
        }
    }

    func test_decodable_memberwise() throws {
        let decoder = JSONDecoder()
        var json: Data

        decoder.semanticVersionDecodingStrategy = .memberwise

        json = """
        {
            "major": 1,
            "minor": 2,
            "patch": 3,
            "preRelease": "a.4",
            "build": "42.7"
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(SemanticVersion.self, from: json),
            SemanticVersion(1, 2, 3, "a.4", "42.7")
        )

        json = """
        [
            {
                "major": 1,
                "minor": 2,
                "patch": 3,
                "preRelease": "a.4",
                "build": "42.7"
            },{
                "major": 7,
                "minor": 7,
                "patch": 7,
                "preRelease": "",
                "build": ""
            }
        ]
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode([SemanticVersion].self, from: json),
            [SemanticVersion(1, 2, 3, "a.4", "42.7"), SemanticVersion(7, 7, 7)]
        )

        struct Foo: Decodable, Equatable {
            let v: SemanticVersion
        }

        json = """
        {
            "v": {
                "major": 1,
                "minor": 2,
                "patch": 3,
                "preRelease": "a.4",
                "build": "42.7"
            }
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Foo.self, from: json),
            Foo(v: SemanticVersion(1, 2, 3, "a.4", "42.7"))
        )

        json = """
        {
            "v": {
                "major": 1,
                "preRelease": "a.4",
                "build": "42.7"
            }
        }
        """.data(using: .utf8)!
        XCTAssertThrowsError(_ = try decoder.decode(Foo.self, from: json)) { error in
            switch error as? DecodingError {
            case .keyNotFound(let key, let context):
                XCTAssertEqual("minor", key.stringValue)
                XCTAssertEqual(["v"], context.codingPath.map(\.stringValue))
            default:
                XCTFail("Expected DecodingError.keyNotFound, got \(error)")
            }
        }
    }
}
