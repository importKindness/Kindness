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

infix operator <*>: FunctorPrecedence
infix operator <*: FunctorPrecedence
infix operator *>: FunctorPrecedence

/// HKT tag type for types that conform to `Apply`
public protocol ApplyTag: FunctorTag {

    /// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
    ///
    /// - Parameter fab: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
    /// - Returns: Function `(KindApplication<FTag, A>) -> KindApplication<FTag, B>`
    static func _apply<A, B>(
        _ fab: KindApplication<Self, (A) -> B>
    ) -> (KindApplication<Self, A>) -> KindApplication<Self, B>
}

/// A `Functor` that supports applying a wrapped function to wrapped arguments:
/// Applying `F<(A) -> B>` to `F<A>` to get `F<B>`
public protocol Apply: Functor where K1Tag: ApplyTag {

    /// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
    ///
    /// - Parameter fab: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
    /// - Returns: Function `(KindApplication<FTag, A>) -> KindApplication<FTag, B>`
    static func _apply<A, B>(
        _ fab: KindApplication<K1Tag, (A) -> B>
    ) -> (KindApplication<K1Tag, A>) -> KindApplication<K1Tag, B>
}

public extension Apply {

    /// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
    ///
    /// - Parameter fab: `F<(A) -> B>` wrapping the function to apply
    /// - Returns: Function `(F<A>) -> F<B>`
    static func _apply<F: Apply, G: Apply, H: Apply>(
        _ fab: F
    ) -> (G) -> H where F.K1Tag == G.K1Tag, G.K1Tag == H.K1Tag, F.K1Arg == ((G.K1Arg) -> H.K1Arg) {
        return { fab <*> $0 }
    }
}

// MARK: apply | <*>

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `F<(A) -> B>` wrapping the function to apply
///   - fa: `F<A>` wrapping the argument to pass to the wrapped function
/// - Returns: `F<B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <F: Apply, G: Apply, H: Apply>(
    _ fab: F,
    _ fa: G
) -> H where F.K1Tag == G.K1Tag, G.K1Tag == H.K1Tag, F.K1Arg == ((G.K1Arg) -> H.K1Arg) {
    return (H.unkind • F._apply(fab.kind)) <| fa.kind
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `F<(A) -> B>` wrapping the function to apply
///   - fa: `F<A>` wrapping the argument to pass to the wrapped function
/// - Returns: `KindApplication<FTag, B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <F: Apply, G: Apply, B>(
    _ fab: F,
    _ fa: G
) -> KindApplication<F.K1Tag, B> where F.K1Tag == G.K1Tag, F.K1Arg == ((G.K1Arg) -> B) {
    return F._apply(fab.kind) <| fa.kind
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `F<(A) -> B>` wrapping the function to apply
///   - fa: `KindApplication<FTag, B>` wrapping the argument to pass to the wrapped function
/// - Returns: `F<B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <F: Apply, A, H: Apply>(
    _ fab: F,
    _ fa: KindApplication<F.K1Tag, A>
) -> H where F.K1Tag == H.K1Tag, F.K1Arg == ((A) -> H.K1Arg) {
    return (H.unkind • F._apply(fab.kind)) <| fa
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `F<(A) -> B>` wrapping the function to apply
///   - fa: `KindApplication<FTag, B>` wrapping the argument to pass to the wrapped function
/// - Returns: `KindApplication<FTag, B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <F: Apply, A, B>(
    _ fab: F,
    _ fa: KindApplication<F.K1Tag, A>
) -> KindApplication<F.K1Tag, B> where F.K1Arg == ((A) -> B) {
    return F._apply(fab.kind) <| fa
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
///   - fa: `F<A>` wrapping the argument to pass to the wrapped function
/// - Returns: `F<B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <G: Apply, H: Apply>(
    _ fab: KindApplication<G.K1Tag, (G.K1Arg) -> H.K1Arg>,
    _ fa: G
) -> H where G.K1Tag == H.K1Tag {
    return (H.unkind • G._apply(fab)) <| fa.kind
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
///   - fa: `F<A>` wrapping the argument to pass to the wrapped function
/// - Returns: `KindApplication<FTag, B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <G: Apply, B>(
    _ fab: KindApplication<G.K1Tag, (G.K1Arg) -> B>,
    _ fa: G
) -> KindApplication<G.K1Tag, B> {
    return G._apply(fab) <| fa.kind
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
///   - fa: `KindApplication<FTag, B>` wrapping the argument to pass to the wrapped function
/// - Returns: `F<B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <A, H: Apply>(
    _ fab: KindApplication<H.K1Tag, (A) -> H.K1Arg>,
    _ fa: KindApplication<H.K1Tag, A>
) -> H {
    return (H.unkind • H._apply(fab)) <| fa
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - fab: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
///   - fa: `KindApplication<FTag, B>` wrapping the argument to pass to the wrapped function
/// - Returns: `KindApplication<FTag, B>` resulting from applying the wrapped function to the wrapped argument
public func <*> <FTag: ApplyTag, A, B>(
    _ fab: KindApplication<FTag, (A) -> B>,
    _ fa: KindApplication<FTag, A>
) -> KindApplication<FTag, B> {
    return FTag._apply(fab) <| fa
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `F<(A) -> B>` wrapping the function to apply
/// - Returns: `(F<A>) -> F<B>` that applies the provided wrapped function to the wrapped argument `F<A>`
public func apply<F: Apply, G: Apply, H: Apply>(
    _ f: F
) -> (G) -> H where F.K1Tag == G.K1Tag, G.K1Tag == H.K1Tag, F.K1Arg == ((G.K1Arg) -> H.K1Arg) {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `F<(A) -> B>` wrapping the function to apply
/// - Returns: `(F<A>) -> KindApplication<FTag, B>` that applies the provided wrapped function to the wrapped argument
/// `F<A>`
public func apply<F: Apply, G: Apply, B>(
    _ f: F
) -> (G) -> KindApplication<G.K1Tag, B> where F.K1Tag == G.K1Tag, F.K1Arg == ((G.K1Arg) -> B) {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `F<(A) -> B>` wrapping the function to apply
/// - Returns: `(KindApplication<FTag, A>) -> F<B>` that applies the provided wrapped function to the wrapped argument
/// `KindApplication<FTag, A>`
public func apply<F: Apply, A, H: Apply>(
    _ f: F
) -> (KindApplication<F.K1Tag, A>) -> H where F.K1Tag == H.K1Tag, F.K1Arg == ((A) -> H.K1Arg) {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `F<(A) -> B>` wrapping the function to apply
/// - Returns: `(KindApplication<FTag, A>) -> KindApplication<FTag, B>` that applies the provided wrapped function to
/// the wrapped argument `KindApplication<FTag, A>`
public func apply<F: Apply, A, B>(
    _ f: F
) -> (KindApplication<F.K1Tag, A>) -> KindApplication<F.K1Tag, B> where F.K1Arg == ((A) -> B) {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
/// - Returns: `(F<A>) -> F<B>` that applies the provided wrapped function to the wrapped argument `F<A>`
public func apply<G: Apply, H: Apply>(
    _ f: KindApplication<G.K1Tag, (G.K1Arg) -> H.K1Arg>
) -> (G) -> H where G.K1Tag == H.K1Tag {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
/// - Returns: `(F<A>) -> KindApplication<FTag, B>` that applies the provided wrapped function to the wrapped argument
/// `F<A>`
public func apply<G: Apply, B>(
    _ f: KindApplication<G.K1Tag, (G.K1Arg) -> B>
) -> (G) -> KindApplication<G.K1Tag, B> {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
/// - Returns: `(KindApplication<FTag, A>) -> F<B>` that applies the provided wrapped function to the wrapped argument
/// `KindApplication<FTag, A>`
public func apply<A, H: Apply>(
    _ f: KindApplication<H.K1Tag, (A) -> H.K1Arg>
) -> (KindApplication<H.K1Tag, A>) -> H {
    return curry(<*>) <| f
}

/// Given a function wrapped in a `Functor`, apply that function to arguments wrapped in the same `Functor`
///
/// - Parameters:
///   - f: `KindApplication<FTag, (A) -> B>` wrapping the function to apply
/// - Returns: `(KindApplication<FTag, A>) -> KindApplication<FTag, B>` that applies the provided wrapped function to
/// the wrapped argument `KindApplication<FTag, A>`
public func apply<FTag: ApplyTag, A, B>(
    _ f: KindApplication<FTag, (A) -> B>
) -> (KindApplication<FTag, A>) -> KindApplication<FTag, B> {
    return curry(<*>) <| f
}

// MARK: applyFirst | <*

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <F: Apply, G: Apply>(_ f: F, _ g: G) -> F where F.K1Tag == G.K1Tag {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <F: Apply, G: Apply>(_ f: KindApplication<F.K1Tag, F.K1Arg>, _ g: G) -> F where F.K1Tag == G.K1Tag {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <F: Apply, G: Apply>(_ f: F, _ g: G) -> KindApplication<F.K1Tag, F.K1Arg> where F.K1Tag == G.K1Tag {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <A, G: Apply>(_ f: KindApplication<G.K1Tag, A>, _ g: G) -> KindApplication<G.K1Tag, A> {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <F: Apply, B>(_ f: F, _ g: KindApplication<F.K1Tag, B>) -> F {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <F: Apply, B>(_ f: KindApplication<F.K1Tag, F.K1Arg>, _ g: KindApplication<F.K1Tag, B>) -> F {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <F: Apply, B>(_ f: F, _ g: KindApplication<F.K1Tag, B>) -> KindApplication<F.K1Tag, F.K1Arg> {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func <* <FTag: ApplyTag, A, B>(
    _ f: KindApplication<FTag, A>, _ g: KindApplication<FTag, B>
) -> KindApplication<FTag, A> {
    return const <^> f <*> g
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<F: Apply, G: Apply>(_ f: F) -> (G) -> F where F.K1Tag == G.K1Tag {
    return curry(<*) <| f
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<F: Apply, G: Apply>(
    _ f: KindApplication<F.K1Tag, F.K1Arg>
) -> (G) -> F where F.K1Tag == G.K1Tag {
    return curry(<*) <| f
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<F: Apply, G: Apply>(
    _ f: F
) -> (G) -> KindApplication<F.K1Tag, F.K1Arg> where F.K1Tag == G.K1Tag {
    return curry(<*) <| f
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<A, G: Apply>(_ f: KindApplication<G.K1Tag, A>) -> (G) -> KindApplication<G.K1Tag, A> {
    return curry(<*) <| f
}



/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<F: Apply, B>(_ f: F) -> (KindApplication<F.K1Tag, B>) -> F {
    return curry(<*) <| f
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<F: Apply, B>(_ f: KindApplication<F.K1Tag, F.K1Arg>) -> (KindApplication<F.K1Tag, B>) -> F {
    return curry(<*) <| f
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<F: Apply, B>(_ f: F) -> (KindApplication<F.K1Tag, B>) -> KindApplication<F.K1Tag, F.K1Arg> {
    return curry(<*) <| f
}

/// Combine two actions while keeping the result on the left
///
/// - Parameters:
///   - f: Action for which the result will be kept
///   - g: Action for which the result will be ignored
/// - Returns: The result from the left, but with both actions evaluated
public func applyFirst<FTag: ApplyTag, A, B>(
    _ f: KindApplication<FTag, A>
) -> (KindApplication<FTag, B>) -> KindApplication<FTag, A> {
    return curry(<*) <| f
}

// MARK: applySecond | *>

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <F: Apply, G: Apply>(_ f: F, _ g: G) -> G where F.K1Tag == G.K1Tag {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <F: Apply, G: Apply>(_ f: F, _ g: KindApplication<G.K1Tag, G.K1Arg>) -> G where F.K1Tag == G.K1Tag {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <F: Apply, G: Apply>(_ f: F, _ g: G) -> KindApplication<G.K1Tag, G.K1Arg> where F.K1Tag == G.K1Tag {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <F: Apply, B>(_ f: F, _ g: KindApplication<F.K1Tag, B>) -> KindApplication<F.K1Tag, B> {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <A, G: Apply>(_ f: KindApplication<G.K1Tag, A>, _ g: G) -> G {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <A, G: Apply>(_ f: KindApplication<G.K1Tag, A>, _ g: KindApplication<G.K1Tag, G.K1Arg>) -> G {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <A, G: Apply>(_ f: KindApplication<G.K1Tag, A>, _ g: G) -> KindApplication<G.K1Tag, G.K1Arg> {
    return const(id) <^> f <*> g
}

/// Combine two actions while keeping the result on the right
///
/// - Parameters:
///   - f: Action for which the result will be ignored
///   - g: Action for which the result will be kept
/// - Returns: The result from the left, but with both actions evaluated
public func *> <FTag: ApplyTag, A, B>(
    _ f: KindApplication<FTag, A>, _ g: KindApplication<FTag, B>
) -> KindApplication<FTag, B> {
    return const(id) <^> f <*> g
}

// MARK: Lifts

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<F: Apply, G: Apply, H: Apply>(
    _ f: @escaping (F.K1Arg) -> (G.K1Arg) -> H.K1Arg
) -> (F) -> (G) -> H where F.K1Tag == G.K1Tag, F.K1Tag == H.K1Tag {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<A, G: Apply, H: Apply>(
    _ f: @escaping (A) -> (G.K1Arg) -> H.K1Arg
) -> (KindApplication<G.K1Tag, A>) -> (G) -> H where G.K1Tag == H.K1Tag {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<F: Apply, B, H: Apply>(
    _ f: @escaping (F.K1Arg) -> (B) -> H.K1Arg
) -> (F) -> (KindApplication<F.K1Tag, B>) -> H where F.K1Tag == H.K1Tag {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<F: Apply, G: Apply, C>(
    _ f: @escaping (F.K1Arg) -> (G.K1Arg) -> C
) -> (F) -> (G) -> KindApplication<F.K1Tag, C> where F.K1Tag == G.K1Tag {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<A, B, H: Apply>(
    _ f: @escaping (A) -> (B) -> H.K1Arg
) -> (KindApplication<H.K1Tag, A>) -> (KindApplication<H.K1Tag, B>) -> H {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<A, G: Apply, C>(
    _ f: @escaping (A) -> (G.K1Arg) -> C
) -> (KindApplication<G.K1Tag, A>) -> (G) -> KindApplication<G.K1Tag, C> {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<F: Apply, B, C>(
    _ f: @escaping (F.K1Arg) -> (B) -> C
) -> (F) -> (KindApplication<F.K1Tag, B>) -> KindApplication<F.K1Tag, C> {
    return { fa in { ga in f <^> fa <*> ga } }
}

/// Lifts a function with 2 arguments to work in the context of an `Apply` type constructor
///
/// - Parameter f: Function to lift
/// - Returns: Function with arguments and return values inside an inferred `Apply` type constructor.
public func lift2<FTag: ApplyTag, A, B, C>(
    _ f: @escaping (A) -> (B) -> C
) -> (KindApplication<FTag, A>) -> (KindApplication<FTag, B>) -> KindApplication<FTag, C> {
    return { fa in { ga in f <^> fa <*> ga } }
}
