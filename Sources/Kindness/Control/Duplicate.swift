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

/// HKT tag type for types that conform to `Duplicate`
public protocol DuplicateTag: FunctorTag {
    /// `_duplicate` implementation for the tagged `Duplicate`.
    static func _duplicate<A>(_ w: KindApplication<Self, A>) -> KindApplication<Self, KindApplication<Self, A>>
}

/// Extends `Functor` with the ability to nest values with additional layers of context.
public protocol Duplicate: Functor where K1Tag: DuplicateTag {
    /// Given a value with context `F<A>`, nest it in another level of context to `F<F<A>>`.
    ///
    /// - Parameter w: `F<A>` value in context.
    /// - Returns: `F<F<A>>` result of nesting the value in another level of context.
    func _duplicate() -> KindApplication<K1Tag, K1Self>
}

/// Given a value with context `F<A>`, nest it in another level of context to `F<F<A>>`.
///
/// - Parameter w: `F<A>` value in context.
/// - Returns: `F<F<A>>` result of nesting the value in another level of context.
public func duplicate<F: Duplicate, G: Duplicate>(_ w: F) -> G where G.K1Tag == F.K1Tag, G.K1Arg == F {
    return G.unkind(F.unkind <^> w._duplicate())
}

/// Given a value with context `F<A>`, nest it in another level of context to `F<F<A>>`.
///
/// - Parameter w: `F<A>` value in context.
/// - Returns: `F<F<A>>` result of nesting the value in another level of context.
public func duplicate<F: Duplicate>(_ w: F) -> KindApplication<F.K1Tag, F> {
    return F.unkind <^> w._duplicate()
}

/// Given a value with context `F<A>`, nest it in another level of context to `F<F<A>>`.
///
/// - Parameter w: `F<A>` value in context.
/// - Returns: `F<F<A>>` result of nesting the value in another level of context.
public func duplicate<A, G: Duplicate>(
    _ w: KindApplication<G.K1Tag, A>
) -> G where G.K1Arg == KindApplication<G.K1Tag, A> {
    return G.unkind(G.K1Tag._duplicate(w))
}

/// Given a value with context `F<A>`, nest it in another level of context to `F<F<A>>`.
///
/// - Parameter w: `F<A>` value in context.
/// - Returns: `F<F<A>>` result of nesting the value in another level of context.
public func duplicate<FTag: DuplicateTag, A>(
    _ w: KindApplication<FTag, A>
) -> KindApplication<FTag, KindApplication<FTag, A>> {
    return FTag._duplicate(w)
}
