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

infix operator >>-: MonadPrecedence
infix operator -<<: MonadPrecedence
infix operator >=>: MonadPrecedence
infix operator <=<: MonadPrecedence

public protocol BindTag {
    static func _bind<A, B>(
        _ m: KindApplication<Self, A>, _ f: @escaping (A) -> KindApplication<Self, B>
    ) -> KindApplication<Self, B>
}

public protocol Bind: Apply where K1Tag: BindTag {
    /// Compose two operations with the second being determined by the output of the first
    ///
    /// - Parameter f: Function converting output of the receiver into a subsequent operation
    /// - Returns: Operation that represents performing the receiver and the return of the provided function in sequence
    func _bind<B>(_ f: @escaping (K1Arg) -> KindApplication<K1Tag, B>) -> KindApplication<K1Tag, B>
}

public extension Bind where K1Arg: Bind, K1Arg.K1Tag == K1Tag {
    func _join() -> K1Arg {
        return self >>- id
    }
}

// MARK: bind | >>-

/// Compose two operations with the right being determined by the output of the left
///
/// - Parameters:
///   - m: First operation
///   - f: Function converting output of the left operation into a subsequent operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that left operation in sequence
public func >>- <M: Bind, N: Bind>(_ m: M, _ f: @escaping (M.K1Arg) -> N) -> N where M.K1Tag == N.K1Tag {
    return (N.unkind • m._bind) <| N.kind • f
}

/// Compose two operations with the right being determined by the output of the left
///
/// - Parameters:
///   - m: First operation
///   - f: Function converting output of the left operation into a subsequent operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that left operation in sequence
public func >>- <A, N: Bind>(_ m: KindApplication<N.K1Tag, A>, _ f: @escaping (A) -> N) -> N {
    return N.unkind(N.K1Tag._bind(m, N.kind • f))
}

/// Compose two operations with the right being determined by the output of the left
///
/// - Parameters:
///   - m: First operation
///   - f: Function converting output of the left operation into a subsequent operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that left operation in sequence
public func >>- <M: Bind, B>(
    _ m: M, _ f: @escaping (M.K1Arg) -> KindApplication<M.K1Tag, B>
) -> KindApplication<M.K1Tag, B> {
    return m._bind <| f
}

/// Compose two operations with the right being determined by the output of the left
///
/// - Parameters:
///   - m: First operation
///   - f: Function converting output of the left operation into a subsequent operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that left operation in sequence
public func >>- <FTag: BindTag, A, B>(
    _ m: KindApplication<FTag, A>, _ f: @escaping (A) -> KindApplication<FTag, B>
) -> KindApplication<FTag, B> {
    return FTag._bind(m, f)
}

/// Compose two operations with the left being determined by the output of the right
///
/// - Parameters:
///   - f: Function converting output of the right operation into a subsequent operation
///   - m: First operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that right operation in sequence
public func -<< <M: Bind, N: Bind>(_ f: @escaping (M.K1Arg) -> N, _ m: M) -> N where M.K1Tag == N.K1Tag {
    return m >>- f
}

/// Compose two operations with the left being determined by the output of the right
///
/// - Parameters:
///   - f: Function converting output of the right operation into a subsequent operation
///   - m: First operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that right operation in sequence
public func -<< <A, N: Bind>(_ f: @escaping (A) -> N, _ m: KindApplication<N.K1Tag, A>) -> N {
    return m >>- f
}

/// Compose two operations with the left being determined by the output of the right
///
/// - Parameters:
///   - f: Function converting output of the right operation into a subsequent operation
///   - m: First operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that right operation in sequence
public func -<< <M: Bind, B>(
    _ f: @escaping (M.K1Arg) -> KindApplication<M.K1Tag, B>, _ m: M
) -> KindApplication<M.K1Tag, B> {
    return m >>- f
}

/// Compose two operations with the left being determined by the output of the right
///
/// - Parameters:
///   - f: Function converting output of the right operation into a subsequent operation
///   - m: First operation
/// - Returns: Operation that represents performing the provided operation and the operation resulting from applying the
/// provided function to the output of that right operation in sequence
public func -<< <FTag: BindTag, A, B>(
    _ f: @escaping (A) -> KindApplication<FTag, B>, _ m: KindApplication<FTag, A>
) -> KindApplication<FTag, B> {
    return m >>- f
}

// MARK: composeKliesli | >=>

/// Forward Kliesli composition
public func >=> <A, M: Bind, N: Bind>(
    _ f: @escaping (A) -> M, _ g: @escaping (M.K1Arg) -> N
) -> (A) -> N where M.K1Tag == N.K1Tag {
    return { a in f(a) >>- g }
}

// MARK: composeKlieslieFlipped | <=<

/// Backward Kliesli composition
public func <=< <A, M: Bind, N: Bind>(
    _ g: @escaping (M.K1Arg) -> N, _ f: @escaping (A) -> M
) -> (A) -> N where M.K1Tag == N.K1Tag {
    return { a in f(a) >>- g }
}
