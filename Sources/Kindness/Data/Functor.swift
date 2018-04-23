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
infix operator <&>: FunctorPrecedence
infix operator <^: FunctorPrecedence
infix operator ^>: FunctorPrecedence

/// HKT tag type for `Functor`s.
public protocol FunctorTag {

    /// Implementation of fmap for the tagged `Functor`. This can usually just call the `Functor`'s implementation but
    /// allows for referencing the implementation when the fully qualified `Functor` is not available.
    ///
    /// - Parameter f: Function to be mapped
    /// - Returns: A function from `(KindApplication<SelfTag, A>) -> KindApplication<SelfTag, B>`
    static func fmap<A, B>(_ f: @escaping (A) -> B) -> (KindApplication<Self, A>) -> KindApplication<Self, B>
}

/// A parameterized type that can be mapped over. Requires one method, `fmap`, that given a function `(A) -> B` returns
/// a function `(Self<A>) -> Self<B>.
public protocol Functor: K1 where K1Tag: FunctorTag {

    /// Maps a function `(A) -> B` to `(KindApplication<SelfTag, A>) -> KindApplication<SelfTag, B>`
    ///
    /// - Parameter f: Function to be mapped
    /// - Returns: A function from `(KindApplication<SelfTag, A>) -> KindApplication<SelfTag, B>`
    static func fmap<T>(_ f: @escaping (K1Arg) -> T) -> (K1Self) -> K1Other<T>
}

public extension Functor {

    /// Maps a function `(A) -> B` over self to return `Self<B>`
    ///
    /// - Parameter f: Function to be mapped
    /// - Returns: `Self<B>` result of passing self to the mapped function `(Self<A>) -> Self<B>`
    func fmap<F: Functor>(_ f: @escaping (K1Arg) -> F.K1Arg) -> F where F.K1Tag == K1Tag {
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
    return G.unkind • F.fmap(f) <| fa.kind
}

/// Maps a function `(A) -> B` to `(F<A>) -> KindApplication<FTag, B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `KindApplication<FTag, B>` result of passing `F<A>` to the mapped function
/// `(F<A>) -> KindApplication<FTag, B>`
public func <^> <F: Functor, B>(_ f: @escaping (F.K1Arg) -> B, _ fa: F) -> KindApplication<F.K1Tag, B> {
    return F.fmap(f) <| fa.kind
}

/// Maps a function `(A) -> B` to `(KindApplication<FTag, A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
///   - fa: `F<A>` value to pass to the mapped function
/// - Returns: `F<B>` result of passing `KindApplication<FTag, A>` to the mapped function
/// `KindApplication<FTag, A>) -> F<B>`
public func <^> <A, G: Functor>(_ f: @escaping (A) -> G.K1Arg, _ fa: KindApplication<G.K1Tag, A>) -> G {
    return G.unkind • G.K1Tag.fmap(f) <| fa
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
    return FTag.fmap(f) <| fa
}

/// Maps a function `(A) -> B` to `(F<A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
/// - Returns: Mapped function `(F<A>) -> F<B>`
public func fmap <F: Functor, G: Functor>(_ f: @escaping (F.K1Arg) -> G.K1Arg) -> (F) -> G where F.K1Tag == G.K1Tag {
    return { f <^> $0 }
}

/// Maps a function `(A) -> B` to `(F<A>) -> KindApplication<FTag, B>`
///
/// - Parameters:
///   - f: Function to be mapped
/// - Returns: Mapped function `(F<A>) -> KindApplication<FTag, B>`
public func fmap<F: Functor, B>(_ f: @escaping (F.K1Arg) -> B) -> (F) -> KindApplication<F.K1Tag, B> {
    return { F.fmap(f) <| $0.kind }
}

/// Maps a function `(A) -> B` to `(KindApplication<FTag, A>) -> F<B>`
///
/// - Parameters:
///   - f: Function to be mapped
/// - Returns: Mapped function `(KindApplication<FTag, A>) -> F<B>`
public func fmap<A, G: Functor>(_ f: @escaping (A) -> G.K1Arg) -> (KindApplication<G.K1Tag, A>) -> G {
    return G.unkind • G.K1Tag.fmap(f)
}

// MARK: flipMap | <&>

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
