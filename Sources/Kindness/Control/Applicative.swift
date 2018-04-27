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

/// HKT tag type for `Applicative`s.
public protocol ApplicativeTag: ApplyTag {
    /// Given a value of type `A`, lift that value into `KindApplication<Self, A>`
    ///
    /// - Parameter a: value to lift
    /// - Returns: Kind application of `Self` with type `A` that contains the provided value
    static func _pure<A>(_ a: A) -> KindApplication<Self, A>
}

/// Extends `Apply` with the ability to lift of type A value a into Self<A>
public protocol Applicative: Apply where K1Tag: ApplicativeTag {
    /// Given a value of type `A`, lift that value into `Self` represented as `KindApplication<K1Tag, A>`
    ///
    /// - Parameter a: value to lift
    /// - Returns: Kind application of `K1Tag` with type `A` that contains the provided value
    static func _pure(_ a: K1Arg) -> KindApplication<K1Tag, K1Arg>
}

/// Given a value, lift that value into a value of an inferred `Applicative` type that contains the provided value.
///
/// - Parameter a: value to lift
/// - Returns: Value of an inferred `Applicative` type that contains the provided value
public func pure<A: Applicative>(_ a: A.K1Arg) -> A {
    return (A.unkind • A._pure) <| a
}

/// Given a value, lift that value into a value of an inferred `Applicative` type that contains the provided value.
///
/// - Parameter a: value to lift
/// - Returns: Value of an inferred `Applicative` type represented as a `KindApplication` that contains the provided
/// value
public func pure<ATag: ApplicativeTag, A>(_ a: A) -> KindApplication<ATag, A> {
    return ATag._pure(a)
}

/// Provides an implementation for `Functor` required method `_fmap` based on `_pure` and `<*>`
public protocol FunctorByApplicative: Applicative { }

public extension FunctorByApplicative {
    static func _fmap<T>(_ f: @escaping (K1Arg) -> T) -> (K1Self) -> K1Other<T> {
        return { a in pure(f) <*> a }
    }
}
