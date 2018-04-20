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

infix operator <^>: FunctorPrecedence

public protocol FunctorTag {
    static func _fmap<A, B>(_ f: @escaping (A) -> B) -> (KindApplication<Self, A>) -> KindApplication<Self, B>
}

public protocol Functor: K1 where K1Tag: FunctorTag {
    static func _fmap<T>(_ f: @escaping (K1Arg) -> T) -> (K1Self) -> K1Other<T>
}

public func <^> <F: Functor, G: Functor>(_ f: @escaping (F.K1Arg) -> G.K1Arg, _ fa: F) -> G where F.K1Tag == G.K1Tag {
    return G.unkind • F._fmap(f) <| fa.kind
}

public func <^> <F: Functor, B>(_ f: @escaping (F.K1Arg) -> B, _ fa: F) -> KindApplication<F.K1Tag, B> {
    return F._fmap(f) <| fa.kind
}

public func <^> <A, G: Functor>(_ f: @escaping (A) -> G.K1Arg, _ fa: KindApplication<G.K1Tag, A>) -> G {
    return G.unkind • G.K1Tag._fmap(f) <| fa
}

public func fmap <F: Functor, G: Functor>(_ f: @escaping (F.K1Arg) -> G.K1Arg) -> (F) -> G where F.K1Tag == G.K1Tag {
    return { f <^> $0 }
}

public func fmap<F: Functor, B>(_ f: @escaping (F.K1Arg) -> B) -> (F) -> KindApplication<F.K1Tag, B> {
    return { F._fmap(f) <| $0.kind }
}

public func fmap<A, G: Functor>(_ f: @escaping (A) -> G.K1Arg) -> (KindApplication<G.K1Tag, A>) -> G {
    return G.unkind • G.K1Tag._fmap(f)
}

public extension Functor {
    func fmap<F: Functor>(_ f: @escaping (K1Arg) -> F.K1Arg) -> F where F.K1Tag == K1Tag {
        return f <^> self
    }
}
