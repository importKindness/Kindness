// Copyright © 2018 the Kindness project contributors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

public struct KindApplication<Tag, Arg> {
    public let tag: Tag

    public init(_ tag: Tag) {
        self.tag = tag
    }
}

/// Type parameterized by 1 type (1 generic argument)
public protocol K1 {

    /// Tag to use when representing as a `KindApplication` of the `K1Arg`
    associatedtype K1Tag

    /// Type of the argument in the K1 position
    associatedtype K1Arg

    /// Representation as a `KindApplication` of the `K1Tag`
    var kind: K1Self { get }

    /// Given a `KindApplication` of the `K1Tag` where the `Arg` matches `Self.K1TagArgs`, return an instance / value
    /// of the receiver
    ///
    /// - Parameter kind: `KindApplication` of the `K1Tag` with an `Arg` matching `Self.K1TagArgs`
    /// - Returns: An instance / value of the receiver
    static func unkind(_ kind: K1Self) -> Self
}

public extension K1 {

    /// All type arguments needed for `KindApplication` of the `K1Tag`
    typealias K1TagArgs = K1Arg

    /// Type of `KindApplication` with the same `Arg` as `Self.K1TagArgs`
    typealias K1Self = KindApplication<K1Tag, K1TagArgs>

    /// Type of `KindApplication` with an alternative `Arg` compared to `Self.K1TagArgs`
    typealias K1Other<A> = KindApplication<K1Tag, A>

    /// Static alternative to `var kind: K1Self` for use in function composition.
    ///
    /// - Parameter k: Instance / value of `Self`
    /// - Returns: Representation as a `KindApplication` of the `K1Tag`
    public static func kind(_ k: Self) -> K1Self {
        return k.kind
    }
}

/// Type parameterized by 2 types (2 generic arguments)
public protocol K2: K1 {

    /// Tag to use when representing as a `KindApplication` of `K2Arg` and `K1Arg`
    associatedtype K2Tag

    /// Type of the argument in the K2 position
    associatedtype K2Arg

    /// Representation as a `KindApplication` of the `K2Tag`
    var kind2: K2Self { get }

    /// Given a `KindApplication` of the `K2Tag` where the `Arg` matches `Self.K2TagArgs`, return an instance / value
    /// of the receiver
    ///
    /// - Parameter kind: `KindApplication` of the `K2Tag` with an `Arg` matching `Self.K2TagArgs`
    /// - Returns: An instance / value of the receiver
    static func unkind2(_ kind: K2Self) -> Self
}

public extension K2 {

    /// All type arguments needed for `KindApplication` of the `K2Tag`
    typealias K2TagArgs = (K2Arg, K1TagArgs)

    /// Type of `KindApplication` with the same `Arg` as `Self.K2TagArgs`
    typealias K2Self = KindApplication<K2Tag, K2TagArgs>

    /// Type of `KindApplication` with an alternative `Arg` compared to `Self.K2TagArgs`
    typealias K2Other<A, B> = KindApplication<K2Tag, (A, B)>

    /// Static alternative to `var kind2: K2Self` for use in function composition.
    ///
    /// - Parameter k: Instance / value of `Self`
    /// - Returns: Representation as a `KindApplication` of the `K2Tag`
    static func kind2(_ k: Self) -> K2Self {
        return k.kind2
    }
}

/// Type parameterized by 3 types (3 generic arguments)
public protocol K3: K2 {

    /// Tag to use when representing as a `KindApplication` of `K3Arg`, `K2Arg` and `K1Arg`
    associatedtype K3Tag

    /// Type of the argument in the K3 position
    associatedtype K3Arg

    /// Representation as a `KindApplication` of the `K3Tag`
    var kind3: K3Self { get }

    /// Given a `KindApplication` of the `K3Tag` where the `Arg` matches `Self.K3TagArgs`, return an instance / value
    /// of the receiver
    ///
    /// - Parameter kind: `KindApplication` of the `K3Tag` with an `Arg` matching `Self.K3TagArgs`
    /// - Returns: An instance / value of the receiver
    static func unkind3(_ kind: K3Self) -> Self
}

public extension K3 {

    /// All type arguments needed for `KindApplication` of the `K3Tag`
    typealias K3TagArgs = (K3Arg, K2TagArgs)

    /// Type of `KindApplication` with the same `Arg` as `Self.K3TagArgs`
    typealias K3Self = KindApplication<K3Tag, K3TagArgs>

    /// Type of `KindApplication` with alternative `Arg` compared to `Self.K3TagArgs`
    typealias K3Other<A, B, C> = KindApplication<K3Tag, (A, (B, C))>

    /// Static alternative to `var kind3: K3Self` for use in function composition.
    ///
    /// - Parameter k: Instance / value of `Self`
    /// - Returns: Representation as a `KindApplication` of the `K2Tag`
    static func kind3(_ k: Self) -> K3Self {
        return k.kind3
    }
}
