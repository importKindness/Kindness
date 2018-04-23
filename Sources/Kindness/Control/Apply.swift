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
