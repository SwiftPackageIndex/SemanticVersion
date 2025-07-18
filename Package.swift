// swift-tools-version:5.6

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

import PackageDescription

let package = Package(
    name: "SemanticVersion",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0"),
        .watchOS("9.0"),
        .tvOS("16.0"),
    ],
    products: [
        .library(
            name: "SemanticVersion",
            targets: ["SemanticVersion"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SemanticVersion",
                dependencies: [],
                resources: resources),
        .testTarget(name: "SemanticVersionTests", dependencies: ["SemanticVersion"]),
    ]
)

#if canImport(Foundation)
let resources: [Resource] = [.process("Documentation.docc")]
#else
let resources: [Resource] = []
#endif