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

infix operator <^>: InfixL4
infix operator <&>: InfixL4
infix operator <^: InfixL4
infix operator ^>: InfixL4

/// HKT tag type for `Functor`s.
public protocol FunctorTag {

    /// `_fmap` implementation for the tagged `Functor`.
    static func _fmap<A, B>(_ f: @escaping (A) -> B, _ value: KindApplication<Self, A>) -> KindApplication<Self, B>
}

/// A parameterized type that can be mapped over. Requires one method, `fmap`, that given a function `(A) -> B` returns
/// a function `(Self<A>) -> Self<B>.
///
/// Laws:
///
///     Identity: fmap(id) == id
///     Composition: fmap(f <<< g) = fmap(f) <<< fmap(g)
public protocol Functor: K1 where K1Tag: FunctorTag {

    /// Maps a function `(A) -> B` to `(KindApplication<SelfTag, A>) -> KindApplication<SelfTag, B>`
    ///
    /// - Parameter f: Function to be mapped
    /// - Returns: A function from `(KindApplication<SelfTag, A>) -> KindApplication<SelfTag, B>`
    static func _fmap<T>(_ f: @escaping (K1Arg) -> T, _ value: K1Self) -> K1Other<T>
}

public extension Functor {

    /// Maps a function `(A) -> B` over self to return `Self<B>`
    ///
    /// - Parameter f: Function to be mapped
    /// - Returns: `Self<B>` result of passing self to the mapped function `(Self<A>) -> Self<B>`
    func _fmap<F: Functor>(_ f: @escaping (K1Arg) -> F.K1Arg) -> F where F.K1Tag == K1Tag {
        return f <^> self
    }
}

// MARK: fmap | <^>

/// Maps a function `(A) -> B` to `(F<A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `F<B>` result of passing `F<A>` to the mapped function `(F<A>) -> F<B>`
public func <^> <F: Functor, G: Functor>(_ f: @escaping (F.K1Arg) -> G.K1Arg, _ fa: F) -> G where F.K1Tag == G.K1Tag {
    return G.unkind • (F._fmap <| f) <| fa.kind
}

/// Maps a function `(A) -> B` to `(F<A>) -> KindApplication<FTag, B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `KindApplication<FTag, B>` result of passing `F<A>` to the mapped function
/// `(F<A>) -> KindApplication<FTag, B>`
public func <^> <F: Functor, B>(_ f: @escaping (F.K1Arg) -> B, _ fa: F) -> KindApplication<F.K1Tag, B> {
    return (F._fmap <| f) <| fa.kind
}

/// Maps a function `(A) -> B` to `(KindApplication<FTag, A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `F<B>` result of passing `KindApplication<FTag, A>` to the mapped function
/// `KindApplication<FTag, A>) -> F<B>`
public func <^> <A, G: Functor>(_ f: @escaping (A) -> G.K1Arg, _ fa: KindApplication<G.K1Tag, A>) -> G {
    return G.unkind • (G.K1Tag._fmap <| f) <| fa
}

/// Maps a function `(A) -> B` to `(KindApplication<FTag, A>) -> KindApplication<FTag, B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `F<B>` result of passing `F<A>` to the mapped function
/// `(KindApplication<FTag, A>) -> KindApplication<FTag, B>`
public func <^> <FTag: FunctorTag, A, B>(
    _ f: @escaping (A) -> B,
    _ fa: KindApplication<FTag, A>
) -> KindApplication<FTag, B> {
    return (FTag._fmap <| f) <| fa
}

/// Maps a function `(A) -> B` to `(F<A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `F<B>` result of passing `F<A>` to the mapped function `(F<A>) -> F<B>`
public func fmap <F: Functor, G: Functor>(
    _ f: @escaping (F.K1Arg) -> G.K1Arg, _ value: F
) -> G where F.K1Tag == G.K1Tag {
    return f <^> value
}

/// Maps a function `(A) -> B` to `(F<A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `KindApplication<FTag, B>` result of passing `F<A>` to the mapped function
/// `(F<A>) -> KindApplication<FTag, B>`
public func fmap<F: Functor, B>(_ f: @escaping (F.K1Arg) -> B, _ value: F) -> KindApplication<F.K1Tag, B> {
    return F._fmap(f, value.kind)
}

/// Maps a function `(A) -> B` to `(F<A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `KindApplication<FTag, A>` value to pass to the mapped function
/// - Returns: `F<B>` result of passing `KindApplication<FTag, A>` to the mapped function
/// `(KindApplication<FTag, A>) -> F<B>`
public func fmap<A, G: Functor>(_ f: @escaping (A) -> G.K1Arg, _ value: KindApplication<G.K1Tag, A>) -> G {
    return (G.unkind • (G.K1Tag._fmap <| f)) <| value
}

/// Maps a function `(A) -> B` to `(F<A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `FKindApplication<FTag, A>` value to pass to the mapped function
/// - Returns: `KindApplication<FTag, B>` result of passing `KindApplication<FTag, A>` to the mapped function
/// `(KindApplication<FTag, A>) -> KindApplication<FTag, B>`
public func fmap<FTag: FunctorTag, A, B>(
    _ f: @escaping (A) -> B,
    _ value: KindApplication<FTag, A>
) -> KindApplication<FTag, B> {
    return FTag._fmap(f, value)
}

// MARK: mapFlipped | <&>

/// Flipped version of `<^>`
///
/// - Parameters:
///   - fa: `F<A>` value to pass to the mapped function
///   - f: Function to be mapped
/// - Returns: `F<B>` result of passing `F<A>` to the mapped function `(F<A>) -> F<B>`
public func <&> <F: Functor, G: Functor>(_ fa: F, _ f: @escaping (F.K1Arg) -> G.K1Arg) -> G where F.K1Tag == G.K1Tag {
    return f <^> fa
}

/// Flipped version of `<^>`
///
/// - Parameters:
///   - fa: `F<A>` value to pass to the mapped function
///   - f: Function to be mapped
/// - Returns: `KindApplication<FTag, B>` result of passing `F<A>` to the mapped function
/// `(F<A>) -> KindApplication<FTag, B>`
public func <&> <F: Functor, B>(_ fa: F, _ f: @escaping (F.K1Arg) -> B) -> KindApplication<F.K1Tag, B> {
    return f <^> fa
}

/// Flipped version of `<^>`
///
/// - Parameters:
///   - fa: `F<A>` value to pass to the mapped function
///   - f: Function to be mapped
/// - Returns: `F<B>` result of passing `KindApplication<FTag, A>` to the mapped function
/// `KindApplication<FTag, A>) -> F<B>`
public func <&> <A, G: Functor>(_ fa: KindApplication<G.K1Tag, A>, _ f: @escaping (A) -> G.K1Arg) -> G {
    return f <^> fa
}

/// Flipped version of `<^>`
///
/// - Parameters:
///   - fa: `F<A>` value to pass to the mapped function
///   - f: Function to be mapped
/// - Returns: `F<B>` result of passing `F<A>` to the mapped function
/// `(KindApplication<FTag, A>) -> KindApplication<FTag, B>`
public func <&> <FTag: FunctorTag, A, B>(
    _ fa: KindApplication<FTag, A>,
    _ f: @escaping (A) -> B
) -> KindApplication<FTag, B> {
    return f <^> fa
}

// MARK: voidRight | <^

/// Map the value of the `Functor` on the right to the value provided on the left, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - b: Return value to use
///   - fa: The `Functor` to map to the provided value
/// - Returns: F<B> where B is the type of the provided return value
public func <^ <F: Functor, G: Functor>(_ b: G.K1Arg, fa: F) -> G where F.K1Tag == G.K1Tag {
    return const(b) <^> fa
}

/// Map the value of the `Functor` on the right to the value provided on the left, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - b: Return value to use
///   - fa: The `Functor` to map to the provided value
/// - Returns: KindApplication<FTag, B> where B is the type of the provided return value
public func <^ <F: Functor, B>(_ b: B, fa: F) -> KindApplication<F.K1Tag, B> {
    return const(b) <^> fa
}

/// Map the value of the `Functor` on the right to the value provided on the left, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - b: Return value to use
///   - fa: The `KindApplication<FTag, A>` to map to the provided value
/// - Returns: F<B> where B is the type of the provided return value
public func <^ <F: Functor, A>(_ b: F.K1Arg, fa: KindApplication<F.K1Tag, A>) -> F {
    return const(b) <^> fa
}

/// Map the value of the `Functor` on the right to the value provided on the left, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - b: Return value to use
///   - fa: The `KindApplication<FTag, A>` to map to the provided value
/// - Returns: KindApplication<FTag, B> where B is the type of the provided return value
public func <^ <FTag: FunctorTag, A, B>(_ b: B, fa: KindApplication<FTag, A>) -> KindApplication<FTag, B> {
    return const(b) <^> fa
}

// MARK: voidLeft | ^>

/// Map the value of the `Functor` on the left to the value provided on the right, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - fa: The `Functor` to map to the provided value
///   - b: Return value to use
/// - Returns: F<B> where B is the type of the provided return value
public func ^> <F: Functor, G: Functor>(_ fa: F, _ b: G.K1Arg) -> G where F.K1Tag == G.K1Tag {
    return const(b) <^> fa
}

/// Map the value of the `Functor` on the left to the value provided on the right, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - fa: The `Functor` to map to the provided value
///   - b: Return value to use
/// - Returns: KindApplication<FTag, B> where B is the type of the provided return value
public func ^> <F: Functor, B>(_ fa: F, _ b: B) -> KindApplication<F.K1Tag, B> {
    return const(b) <^> fa
}

/// Map the value of the `Functor` on the left to the value provided on the right, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - fa: The `KindApplication<FTag, A>` to map to the provided value
///   - b: Return value to use
/// - Returns: F<B> where B is the type of the provided return value
public func ^> <F: Functor, A>(_ fa: KindApplication<F.K1Tag, A>, _ b: F.K1Arg) -> F {
    return const(b) <^> fa
}

/// Map the value of the `Functor` on the left to the value provided on the right, ignoring the original value of the
/// `Functor`.
///
/// - Parameters:
///   - fa: The `KindApplication<FTag, A>` to map to the provided value
///   - b: Return value to use
/// - Returns: KindApplication<FTag, B> where B is the type of the provided return value
public func ^> <FTag: FunctorTag, A, B>(_ fa: KindApplication<FTag, A>, _ b: B) -> KindApplication<FTag, B> {
    return const(b) <^> fa
}

// MARK: void

/// Discard the output value of the provided `Functor`
///
/// - Parameter fa: `Functor` for which the output value should be discarded
/// - Returns: `F<Void>` resulting from mapping all output values of `Functor` to `Void`
public func void<F: Functor, G: Functor>(_ fa: F) -> G where F.K1Tag == G.K1Tag, G.K1Arg == Void {
    return () <^ fa
}

/// Discard the output value of the provided `Functor`
///
/// - Parameter fa: `Functor` for which the output value should be discarded
/// - Returns: `KindApplication<FTag, Void>` resulting from mapping all output values of `Functor` to `Void`
public func void<F: Functor>(_ fa: F) -> KindApplication<F.K1Tag, ()> {
    return () <^ fa
}

/// Discard the output value of the provided `Functor`
///
/// - Parameter fa: `KindApplication<FTag, A>` for which the output value should be discarded
/// - Returns: `F<Void>` resulting from mapping all output values of `Functor` to `Void`
public func void<F: Functor, A>(_ fa: KindApplication<F.K1Tag, A>) -> F where F.K1Arg == Void {
    return () <^ fa
}

/// Discard the output value of the provided `Functor`
///
/// - Parameter fa: `KindApplication<FTag, A>` for which the output value should be discarded
/// - Returns: `KindApplication<FTag, Void>` resulting from mapping all output values of `Functor` to `Void`
public func void<FTag: FunctorTag, A>(_ fa: KindApplication<FTag, A>) -> KindApplication<FTag, Void> {
    return () <^ fa
}
