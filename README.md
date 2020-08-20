# SemanticVersion

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
let v200 = SemanticVersion("2.0.0-b1")!
v200.isStable        // true
v200.isPreRelease    // false
v200.isMajorRelease  // false
v200.isMinorRelease  // false
v200.isPatchRelease  // true

// Supports beta versions
let v300 = SemanticVersion("3.0.0-rc1-test")!
v300.isStable        // false
v300.isPreRelease    // true
v300.isMajorRelease  // false
v300.isMinorRelease  // false
v300.isPatchRelease  // false
v300.major           // 3
v300.minor           // 0
v300.patch           // 0
v300.preRelease      // "rc1-test"

// SemanticVersion is Comparable and Equatable
v123 < v200          // true
SemanticVersion("2.0.0")! < SemanticVersion("2.0.0-b1")!  // true
v123 == SemanticVersion("1.2.3")  // true
SemanticVersion("v1.2.3-beta1+build5")
    == SemanticVersion(1, 2, 3, "beta1", "build5")  // true

// SemanticVersion is Hashable
let dict = [         // [{major 3, minor 0, patch 0,...
    v123: 1,
    v200: 2,
    v300: 3
]

// SemanticVersion is Codable
let data = try JSONEncoder().encode(v123)  // 58 bytes
let decoded = try JSONDecoder().decode(SemanticVersion.self, from: data)  // 1.2.3
decoded == v123  // true
```
