[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftPackageIndex%2FSemanticVersion%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SwiftPackageIndex/SemanticVersion)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftPackageIndex%2FSemanticVersion%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SwiftPackageIndex/SemanticVersion)

# 🏷 SemanticVersion

SemanticVersion is a simple `Codable`, `Comparable`, `Equatable`, `Hashable`, and `LosslessStringConvertible` struct that can represent semantic versions.

Here's what using `SemanticVersion` looks like in practise:

```swift
import SemanticVersion
import Foundation

// Query semantic version components
let v123 = SemanticVersion(1, 2, 3)
v123.isStable        // true
v123.isPreRelease    // false
v123.isMajorRelease  // false
v123.isMinorRelease  // false
v123.isPatchRelease  // true

// Parse semantic version from String
let v200 = SemanticVersion("2.0.0")!
v200.isStable        // true
v200.isPreRelease    // false
v200.isMajorRelease  // true
v200.isMinorRelease  // false
v200.isPatchRelease  // false

// Supports beta versions
let v300rc1 = SemanticVersion("3.0.0-rc1-test")!
v300rc1.isStable        // false
v300rc1.isPreRelease    // true
v300rc1.isMajorRelease  // false
v300rc1.isMinorRelease  // false
v300rc1.isPatchRelease  // false
v300rc1.major           // 3
v300rc1.minor           // 0
v300rc1.patch           // 0
v300rc1.preRelease      // "rc1-test"

// SemanticVersion is Comparable and Equatable
v123 < v200          // true
SemanticVersion("2.0.0")! < SemanticVersion("2.0.1")!  // true
// NB: beta versions come before their releases
SemanticVersion("2.0.0")! > SemanticVersion("2.0.0-b1")!  // true
v123 == SemanticVersion("1.2.3")  // true
SemanticVersion("v1.2.3-beta1+build5")
    == SemanticVersion(1, 2, 3, "beta1", "build5")  // true

// SemanticVersion is Hashable
let dict = [         // [{major 3, minor 0, patch 0,...
    v123: 1,
    v200: 2,
    v300rc1: 3
]

// SemanticVersion is Codable
// Note: the strategy defaults to `.semverString`
let stringEncoder = JSONEncoder()
stringEncoder.semanticVersionEncodingStrategy = .semverString
let stringDecoder = JSONDecoder()
stringDecoder.semanticVersionDecodingStrategy = .semverString
let stringData = try stringEncoder.encode(v123) // 7 bytes -> "1.2.3", including quotes
let stringDecoded = try stringDecoder.decode(SemanticVersion.self, from: stringData)  // 1.2.3
stringDecoded == v123  // true

let memberwiseEncoder = JSONEncoder()
memberwiseEncoder.semanticVersionEncodingStrategy = .memberwise
let memberwiseDecoder = JSONDecoder()
memberwiseDecoder.semanticVersionDecodingStrategy = .memberwise
let memberwiseData = try memberwiseEncoder.encode(v123)  // 58 bytes
let memberwiseDecoded = try memberwiseDecoder.decode(SemanticVersion.self, from: memberwiseData)  // 1.2.3
memberwiseDecoded == v123  // true
```
