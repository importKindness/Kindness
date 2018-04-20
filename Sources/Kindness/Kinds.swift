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

public protocol K1 {
    associatedtype K1Tag
    associatedtype K1Arg
    typealias K1TagArgs = K1Arg
    typealias K1Self = KindApplication<K1Tag, K1TagArgs>
    typealias K1Other<A> = KindApplication<K1Tag, A>

    var kind: K1Self { get }

    static func unkind(_ kind: K1Self) -> Self
}

extension K1 {
    public static func kind(_ k: Self) -> K1Self {
        return k.kind
    }
}

public protocol K2: K1 {
    associatedtype K2Tag
    associatedtype K2Arg
    typealias K2TagArgs = (K2Arg, K1TagArgs)
    typealias K2Self = KindApplication<K2Tag, K2TagArgs>
    typealias K2Other<A, B> = KindApplication<K2Tag, (A, B)>

    var kind2: K2Self { get }

    static func unkind2(_ kind: K2Self) -> Self
}

extension K2 {
    public static func kind2(_ k: Self) -> K2Self {
        return k.kind2
    }
}

public protocol K3: K2 {
    associatedtype K3Tag
    associatedtype K3Arg
    typealias K3TagArgs = (K3Arg, K2TagArgs)
    typealias K3Self = KindApplication<K3Tag, K3TagArgs>
    typealias K3Other<A, B, C> = KindApplication<K3Tag, (A, B, C)>

    var kind3: K3Self { get }

    static func unkind3(_ kind: K3Self) -> Self
}

extension K3 {
    public static func kind(_ k: Self) -> K3Self {
        return k.kind3
    }
}
