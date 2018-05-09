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

infix operator <<-: InfixR1
infix operator ->>: InfixL1
infix operator =>=: InfixR1
infix operator =<=: InfixR1

/// HKT tag type for types that conform to `Extend`
public protocol ExtendTag: FunctorTag {
    /// `_extend` implementation for the tagged `Extend`.
    static func _extend<A, B>(
        _ f: @escaping (KindApplication<Self, A>) -> B, _ w: KindApplication<Self, A>
    ) -> KindApplication<Self, B>
}

/// Extends `Functor` with the ability to take a local operation and apply it to all of a context `F`.
///
/// Laws:
///
///     Associativity: extend f <<< extend g = extend (f <<< extend g)
public protocol Extend: Functor where K1Tag: ExtendTag {
    /// Extend an operation with some context to apply globally.
    ///
    /// - Parameter f: Function that when given a value `A` in context `F`, returns a `B` for that value.
    /// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `F<A>`.
    func _extend<B>(_ f: @escaping (K1Self) -> B) -> KindApplication<K1Tag, B>
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func <<- <F: Extend, G: Extend>(_ f: @escaping (F) -> G.K1Arg, _ w: F) -> G where F.K1Tag == G.K1Tag {
    return G.unkind(w._extend(f • F.unkind))
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func <<- <A, G: Extend>(
    _ f: @escaping (KindApplication<G.K1Tag, A>) -> G.K1Arg, _ w: KindApplication<G.K1Tag, A>
) -> G {
    return G.unkind(G.K1Tag._extend(f, w))
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func <<- <F: Extend, B>(_ f: @escaping (F) -> B, _ w: F) -> KindApplication<F.K1Tag, B> {
    return w._extend(f • F.unkind)
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func <<- <FTag: ExtendTag, A, B>(
    _ f: @escaping (KindApplication<FTag, A>) -> B, _ w: KindApplication<FTag, A>
) -> KindApplication<FTag, B> {
    return FTag._extend(f, w)
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func extend<F: Extend, G: Extend>(_ f: @escaping (F) -> G.K1Arg, _ w: F) -> G where F.K1Tag == G.K1Tag {
    return G.unkind(w._extend(f • F.unkind))
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func extend<A, G: Extend>(
    _ f: @escaping (KindApplication<G.K1Tag, A>) -> G.K1Arg, _ w: KindApplication<G.K1Tag, A>
    ) -> G {
    return G.unkind(G.K1Tag._extend(f, w))
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func extend<F: Extend, B>(_ f: @escaping (F) -> B, _ w: F) -> KindApplication<F.K1Tag, B> {
    return w._extend(f • F.unkind)
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
///   - w: `F<A>` value to extend with `f`.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func extend<FTag: ExtendTag, A, B>(
    _ f: @escaping (KindApplication<FTag, A>) -> B, _ w: KindApplication<FTag, A>
    ) -> KindApplication<FTag, B> {
    return FTag._extend(f, w)
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - w: `F<A>` value to extend with `f`.
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func ->> <F: Extend, G: Extend>(_ w: F, _ f: @escaping (F) -> G.K1Arg) -> G where F.K1Tag == G.K1Tag {
    return G.unkind(w._extend(f • F.unkind))
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - w: `F<A>` value to extend with `f`.
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func ->> <A, G: Extend>(
    _ w: KindApplication<G.K1Tag, A>, _ f: @escaping (KindApplication<G.K1Tag, A>) -> G.K1Arg
) -> G {
    return G.unkind(G.K1Tag._extend(f, w))
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - w: `F<A>` value to extend with `f`.
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func ->> <F: Extend, B>(_ w: F, _ f: @escaping (F) -> B) -> KindApplication<F.K1Tag, B> {
    return w._extend(f • F.unkind)
}

/// Extend an operation with some context to apply globally.
///
/// - Parameters:
///   - w: `F<A>` value to extend with `f`.
///   - f: Function that when given a value `A` in context `F`, returns a `B` for that value.
/// - Returns: The result of extending the context-dependent operation `(F<A>) -> B` to all of `w`.
public func ->> <FTag: ExtendTag, A, B>(
    _ w: KindApplication<FTag, A>, _ f: @escaping (KindApplication<FTag, A>) -> B
) -> KindApplication<FTag, B> {
    return FTag._extend(f, w)
}

/// Forward CoKliesli composition
public func =>= <F: Extend, G: Extend, C> (
    _ f: @escaping (F) -> G.K1Arg, _ g: @escaping (G) -> C
    ) -> (F) -> C where F.K1Tag == G.K1Tag {
    return { w in return g(f <<- w) }
}

/// Backward CoKliesli composition
public func =<= <F: Extend, G: Extend, C> (
    _ g: @escaping (G) -> C, _ f: @escaping (F) -> G.K1Arg
) -> (F) -> C where F.K1Tag == G.K1Tag {
    return { w in return g(f <<- w) }
}
