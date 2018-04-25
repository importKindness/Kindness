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
    func testApplyHasAssociativeComposition() {
        property("apply has associative composition")
            <- forAll { (fArrows: [ArrowOf<Int8, Int8>], gArrows: [ArrowOf<Int8, Int8>], h: [Int8]) in
                let f = fArrows.map { $0.getArrow }
                let g = gArrows.map { $0.getArrow }

                return (curry(•) <^> f <*> g <*> h) == (f <*> (g <*> h))
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
