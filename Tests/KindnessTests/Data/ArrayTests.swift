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

import XCTest

import SwiftCheck

import Kindness

class ArrayTests: XCTestCase {
    func testApplicativePreservesIdentity() {
        property("applicative preserves identity")
            <- forAll { (xs: [Int8]) in
                return (pure(id) <*> xs) == xs
            }
    }

    func testApplicativePreservesComposition() {
        property("applicative preserves composition")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], gArrows: [ArrowOf<Int8, Int8>], h: [Int8]) in
                let f = fArrows.map { $0.getArrow }
                let g = gArrows.map { $0.getArrow }

                return (pure(curry(•)) <*> f <*> g <*> h) == (f <*> (g <*> h))
            }
    }

    func testApplicativeHomomorphismLaw() {
        property("applying pure(f) to pure(x) is the same as pure(f(x))")
            <- forAll { (fArrow: ArrowOf<Int8, Int8>, x: Int8) in
                let f = fArrow.getArrow
                return (pure(f) <*> (pure(x) as [Int8])) == pure(f(x))
            }
    }

    func testApplicativeInterchangeLaw() {
        property("applying a morphism to a pure value is the same as applying pure($value) to the morphism")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], x: Int8) in
                let f = fArrows.map { $0.getArrow }
                return (f <*> pure(x)) == (pure(curry(|>)(x)) <*> f)
            }
    }

    func testApplyHasAssociativeComposition() {
        property("apply has associative composition")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], gArrows: [ArrowOf<Int8, Int8>], h: [Int8]) in
                let f = fArrows.map { $0.getArrow }
                let g = gArrows.map { $0.getArrow }

                return (curry(•) <^> f <*> g <*> h) == (f <*> (g <*> h))
            }
    }

    func testBindIsAssociative() {
        property("bind is associative")
            <- forAll { (xs: [Int8], fArrow: ArrowOf<Int8, [Int8]>, gArrow: ArrowOf<Int8, [Int8]>) in
                let f = fArrow.getArrow
                let g = gArrow.getArrow

                return ((xs >>- f) >>- g) == (xs >>- { k -> [Int8] in f(k) >>- g })
            }
    }

    func testFunctorPreservesIdentity() {
        property("functor preserves identity")
            <- forAll { (xs: [Int8]) in
                return (id <^> xs) == (id <| xs)
            }
    }

    func testFunctorPreservesComposition() {
        property("functor preserves composition")
            <- forAll { (xs: [Int8], fArrow: ArrowOf<Int8, Int8>, gArrow: ArrowOf<Int8, Int8>) in
                let f = fArrow.getArrow
                let g = gArrow.getArrow
                return (g • f <^> xs) == (fmap(g) • fmap(f) <| xs)
            }
    }

    func testBindLeftIdentity() {
        property("bind has left identity")
            <- forAll { (x: Int8, fArrow: ArrowOf<Int8, [Int8]>) in
                let f = fArrow.getArrow

                return (pure(x) as [Int8] >>- f) == f(x)
            }
    }

    func testBindRightIdentity() {
        property("bind has right identity")
            <- forAll { (x: [Int8]) in
                return (x >>- pure) == x
            }
    }

    func testAppendingToMemptyReturnsAppendedValue() {
        property("appending to mempty returns the appended value")
            <- forAll { (xs: [Int8]) in
                return .mempty <> xs == xs
            }
    }

    func testAppendingMemptyReturnsOriginalValue() {
        property("appending mempty returns original value")
            <- forAll { (xs: [Int8]) in
                return xs <> .mempty == xs
            }
    }

    func testSemigroupBinaryOpIsAssociative() {
        property("semigroup binary op is associative")
            <- forAll { (x: [Int8], y: [Int8], z: [Int8]) in
                return (x <> y) <> z == x <> (y <> z)
            }
    }
}
