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

infix operator <|>: LogicalConjunctionPrecedence

/// HKT tag for types conforming to `Alt`
public protocol AltTag: FunctorTag {

    /// `_alt` implementation for the tagged `Alt`
    static func _alt<A>(
        _ lhs: KindApplication<Self, A>
    ) -> (KindApplication<Self, A>) -> KindApplication<Self, A>
}

/// A type constructor with an associative binary op
///
/// Laws:
///
///     Associativity: (x <|> y) <|> z == x <|> (y <|> z)
///     Distributivity: f <^> (x <|> y) == (f <^> x) <|> (f <^> y)
public protocol Alt: Functor where K1Tag: AltTag {
    /// Append one type constructor to another of the same type
    ///
    /// - Parameter lhs: Type constructor to which the argument of the returned function should be appended
    /// - Returns: Function `(KindApplication<K1Tag, K1Arg>) -> KindApplication<K1Tag, K1Arg>` that appends its argument
    /// to `lhs`
    static func _alt(
        _ lhs: KindApplication<K1Tag, K1Arg>
    ) -> (KindApplication<K1Tag, K1Arg>) -> KindApplication<K1Tag, K1Arg>
}

/// Append rhs after lhs
///
/// - Parameters:
///   - lhs: Type constructor to which `rhs` should be appended
///   - rhs: Type constructor to append to `lhs`
/// - Returns: Result of appending `rhs` to `lhs`
public func <|> <A: Alt>(_ lhs: A, _ rhs: A) -> A {
    return A.unkind(A._alt(lhs.kind) <| rhs.kind)
}

/// Append rhs after lhs
///
/// - Parameters:
///   - lhs: Type constructor to which `rhs` should be appended
///   - rhs: Type constructor to append to `lhs`
/// - Returns: Result of appending `rhs` to `lhs`
public func <|> <A: Alt>(_ lhs: A, _ rhs: KindApplication<A.K1Tag, A.K1Arg>) -> A {
    return A.unkind(A._alt(lhs.kind) <| rhs)
}

/// Append rhs after lhs
///
/// - Parameters:
///   - lhs: Type constructor to which `rhs` should be appended
///   - rhs: Type constructor to append to `lhs`
/// - Returns: Result of appending `rhs` to `lhs`
public func <|> <A: Alt>(_ lhs: KindApplication<A.K1Tag, A.K1Arg>, _ rhs: A) -> A {
    return A.unkind(A._alt(lhs) <| rhs.kind)
}

/// Append rhs after lhs
///
/// - Parameters:
///   - lhs: Type constructor to which `rhs` should be appended
///   - rhs: Type constructor to append to `lhs`
/// - Returns: Result of appending `rhs` to `lhs`
public func <|> <A: Alt>(_ lhs: KindApplication<A.K1Tag, A.K1Arg>, _ rhs: KindApplication<A.K1Tag, A.K1Arg>) -> A {
    return A.unkind(A._alt(lhs) <| rhs)
}
