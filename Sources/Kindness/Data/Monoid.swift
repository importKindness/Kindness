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

/// Semigroup with an empty value. Appending the empty value should return the previous value. Appending a new value to
/// the empty value should return the new value.
public protocol Monoid: Semigroup {
    static var mempty: Self { get }
}

/// Append a value to itself a provided number of times.
///
/// - Parameters:
///   - m: The element to repeat
///   - p: The number of times the element should be appended to itself
/// - Returns: Result of appending the value `m` to itself `p` times
public func power<M: Monoid, N: FixedWidthInteger>(_ m: M, _ p: N) -> M {
    switch p {
    case N.min...0:
        return .mempty

    case 1:
        return m

    case 2...N.max where p % 2 == 0:
        let x = power(m, p / 2)
        return x <> x

    default:
        let x = power(m, p / 2)
        return x <> x <> m
    }
}

// MARK: Dual

/// Type with a `Monoid` conformance where the `<>` operation flips its argument order.
public struct Dual<M: Monoid> {
    public let unDual: M

    public init(_ value: M) {
        self.unDual = value
    }
}

extension Dual: Semigroup {
    public static func <> (lhs: Dual<M>, rhs: Dual<M>) -> Dual<M> {
        return Dual(rhs.unDual <> lhs.unDual)
    }
}

extension Dual: Monoid {
    public static var mempty: Dual<M> {
        return Dual(.mempty)
    }
}

// MARK: Endo

/// Type of functions with the same input and output type.
public struct Endo<A> {
    public let appEndo: (A) -> A

    public init(_ appEndo: @escaping (A) -> A) {
        self.appEndo = appEndo
    }
}

extension Endo: Semigroup {
    public static func <> (lhs: Endo<A>, rhs: Endo<A>) -> Endo<A> {
        return Endo(lhs.appEndo • rhs.appEndo)
    }
}

extension Endo: Monoid {
    public static var mempty: Endo<A> {
        return Endo(id)
    }
}
