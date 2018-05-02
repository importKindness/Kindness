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
    func testAltAssociativity() {
        property("Alt - Associativity: (x <|> y) <|> z == x <|> (y <|> z)")
            <- forAll { (x: [Int8], y: [Int8], z: [Int8]) -> Bool in
                return ((x <|> y) <|> z) == (x <|> (y <|> z))
            }
    }

    func testAltDistributivity() {
        property("Alt - Distributivity: f <^> (x <|> y) == (f <^> x) <|> (f <^> y)")
            <- forAll { (x: [Int8], y: [Int8], fArrow: ArrowOf<Int8, Int8>) -> Bool in
                let f = fArrow.getArrow

                let lhs: [Int8] = f <^> (x <|> y)
                let rhs: [Int8] = (f <^> x) <|> (f <^> y)

                return lhs == rhs
            }
    }

    func testAlternativeDistributivity() {
        property("Alternative - Distributivity: (f <|> g) <*> x == (f <*> x) <|> (g <*> x)")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], gArrows: [ArrowOf<Int8, Int8>], xs: [Int8]) -> Bool in
                let f = fArrows.map { $0.getArrow }
                let g = gArrows.map { $0.getArrow }

                let lhs: [Int8] = (f <|> g) <*> xs

                let rhsL: [Int8] = f <*> xs
                let rhsR: [Int8] = g <*> xs
                let rhs: [Int8] = rhsL <|> rhsR

                return lhs == rhs
            }
    }

    func testAlternativeAnnihilation() {
        property("Alternative - Annihilation: empty <*> f = empty")
            <- forAll { (xs: [Int8]) -> Bool in
                let emptyFs: [(Int8) -> Int8] = .empty

                let lhs: [Int8] = emptyFs <*> xs
                let rhs: [Int8] = .empty

                return lhs == rhs
            }
    }

    func testApplicativeIdentity() {
        property("Applicative - Identity: pure(id) <*> v == v")
            <- forAll { (xs: [Int8]) -> Bool in
                return (pure(id) <*> xs) == xs
            }
    }

    func testApplicativeComposition() {
        property("Applicative - Composition: pure(<<<) <*> f <*> g <*> h == f <*> (g <*> h)")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], gArrows: [ArrowOf<Int8, Int8>], h: [Int8]) -> Bool in
                let f = fArrows.map { $0.getArrow }
                let g = gArrows.map { $0.getArrow }

                let lhs: [Int8] = pure(curry(•)) <*> f <*> g <*> h
                let rhs: [Int8] = f <*> (g <*> h)

                return lhs == rhs
            }
    }

    func testApplicativeHomomorphism() {
        property("Applicative - Homomorphism: pure(f) <*> pure(x) == pure(f(x))")
            <- forAll { (fArrow: ArrowOf<Int8, Int8>, x: Int8) -> Bool in
                let f = fArrow.getArrow
                return (pure(f) <*> (pure(x) as [Int8])) == pure(f(x))
            }
    }

    func testApplicativeInterchange() {
        property("Applicative - Interchange: u <*> pure(y) == pure ((|>) y) <*> u")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], x: Int8) -> Bool in
                let f = fArrows.map { $0.getArrow }

                let lhs: [Int8] = f <*> pure(x)
                let rhs: [Int8] = pure(curry(|>)(x)) <*> f

                return lhs == rhs
            }
    }

    func testApplyAssociativeComposition() {
        property("Apply - Associative composition: (<<<) <^> f <*> g <*> h == f <*> (g <*> h)")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], gArrows: [ArrowOf<Int8, Int8>], h: [Int8]) -> Bool in
                let f = fArrows.map { $0.getArrow }
                let g = gArrows.map { $0.getArrow }

                let lhs: [Int8] = curry(<<<) <^> f <*> g <*> h
                let rhs: [Int8] = f <*> (g <*> h)

                return lhs == rhs
            }
    }

    func testBindAssociativity() {
        property("Bind - Associativity: (x >>- f) >>- g = x >>- { k in f(k) >>- g }")
            <- forAll { (xs: [Int8], fArrow: ArrowOf<Int8, [Int8]>, gArrow: ArrowOf<Int8, [Int8]>) -> Bool in
                let f = fArrow.getArrow
                let g = gArrow.getArrow

                return ((xs >>- f) >>- g) == (xs >>- { k -> [Int8] in f(k) >>- g })
            }
    }

    func testFunctorIdentity() {
        property("Functor - Identity: fmap(id) == id")
            <- forAll { (xs: [Int8]) -> Bool in
                return (id <^> xs) == (id <| xs)
            }
    }

    func testFunctorPreservesComposition() {
        property("Functory - Composition: fmap(f <<< g) = fmap(f) <<< fmap(g))")
            <- forAll { (xs: [Int8], fArrow: ArrowOf<Int8, Int8>, gArrow: ArrowOf<Int8, Int8>) -> Bool in
                let f = fArrow.getArrow
                let g = gArrow.getArrow

                let lhs: [Int8] = fmap(f <<< g, xs)
                let rhs: [Int8] = ((fmap <| f) <<< (fmap <| g)) <| xs

                return lhs == rhs
            }
    }

    func testMonadLeftIdentity() {
        property("Monad - Left Identity: pure(x) >>- f == f(x)")
            <- forAll { (x: Int8, fArrow: ArrowOf<Int8, [Int8]>) in
                let f = fArrow.getArrow

                return (pure(x) as [Int8] >>- f) == f(x)
            }
    }

    func testMonadRightIdentity() {
        property("Monad - Right Identity: x >>- pure == x")
            <- forAll { (x: [Int8]) in
                return (x >>- pure) == x
            }
    }

    func testMonadPlusDistributivity() {
        property("MonadPlus - Distributivity: (x <|> y) >>- f == (x >>- f) <|> (y >>- f)")
            <- forAll { (x: [Int8], y: [Int8], fArrow: ArrowOf<Int8, [Int8]>) -> Bool in
                let f = fArrow.getArrow

                let lhs: [Int8] = (x <|> y) >>- f
                let rhs: [Int8] = (x >>- f) <|> (y >>- f)

                return lhs == rhs
            }
    }

    func testMonadZeroAnnihilation() {
        property("MonadZero - Annihilation: empty >>- f = empty")
            <- forAll { (fArrow: ArrowOf<Int8, [Int8]>) -> Bool in
                let f = fArrow.getArrow

                let lhs: [Int8] = [Int8].empty >>- f
                let rhs: [Int8] = .empty

                return lhs == rhs
            }
    }

    func testMonoidLeftIdentity() {
        property("Mpnoid - Left Identity: mempty <> x == x")
            <- forAll { (xs: [Int8]) in
                return .mempty <> xs == xs
            }
    }

    func testMonoidRightIdentity() {
        property("Monoid - Right Identity: x <> mempty == x")
            <- forAll { (xs: [Int8]) in
                return xs <> .mempty == xs
            }
    }

    func testPlusLeftIdentity() {
        property("Plus - Left Identity: empty <|> x == x")
            <- forAll { (xs: [Int8]) in
                return (.empty <|> xs) == xs
            }
    }

    func testPlusRightIdentity() {
        property("Plus - Right Identity: x <|> empty == x")
            <- forAll { (xs: [Int8]) in
                return (xs <|> .empty) == xs
            }
    }

    func testPlusAnnihilation() {
        property("Plus - Annihilation: f <^> empty == empty")
            <- forAll { (fArrow: ArrowOf<Int8, Int8>) -> Bool in
                let f = fArrow.getArrow

                let lhs: [Int8] = f <^> [Int8].empty
                let rhs: [Int8] = .empty

                return lhs == rhs
            }
    }

    func testEmptyEqualsMempty() {
        XCTAssertEqual([Int8].empty, [Int8].mempty)
    }

    func testSemigroupAssociativity() {
        property("Semigroup - Associativity: (x <> y) <> z == x <> (y <> z)")
            <- forAll { (x: [Int8], y: [Int8], z: [Int8]) in
                return (x <> y) <> z == x <> (y <> z)
            }
    }
}
