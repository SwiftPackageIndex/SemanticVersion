# ``SemanticVersion``

`SemanticVersion` is a struct representing a software or project version according to "Semantic Versioning".

Given a version number MAJOR.MINOR.PATCH, increment the:
1. MAJOR version when you make incompatible API changes,
2. MINOR version when you add functionality in a backwards compatible manner, and
PATCH version when you make backwards compatible bug fixes.
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

Find out more about [Semantic Versioning](https://semver.org).

Once instantiated, you can query a `SemanticVersion` about its components:

```swift
let v123 = SemanticVersion(1, 2, 3)
v123.isStable        // true
v123.isPreRelease    // false
v123.isMajorRelease  // false
v123.isMinorRelease  // false
v123.isPatchRelease  // true
```

You can also instantiate a `SemanticVersion` from a string

```swift
let v200 = SemanticVersion("2.0.0")!
v200.isStable        // true
v200.isPreRelease    // false
v200.isMajorRelease  // true
v200.isMinorRelease  // false
v200.isPatchRelease  // false
```

`SemanticVersion` supports beta versions:

```swift
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
```

`SemanticVersion` is `Comparable` and `Equatable`:

```swift
v123 < v200          // true
SemanticVersion("2.0.0")! < SemanticVersion("2.0.1")!  // true
// NB: beta versions come before their releases
SemanticVersion("2.0.0")! > SemanticVersion("2.0.0-b1")!  // true
v123 == SemanticVersion("1.2.3")  // true
SemanticVersion("v1.2.3-beta1+build5")
    == SemanticVersion(1, 2, 3, "beta1", "build5")  // true
```

`SemanticVersion` is `Hashable`:

```swift
let dict = [         // [{major 3, minor 0, patch 0,...
    v123: 1,
    v200: 2,
    v300rc1: 3
]
```

`SemanticVersion` is `Codable`:

```swift
let data = try JSONEncoder().encode(v123)  // 58 bytes
let decoded = try JSONDecoder().decode(SemanticVersion.self, from: data)  // 1.2.3
decoded == v123  // true
```

