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
    func testAltLaws() {
        checkAltLaws(for: [Int8].self)
    }

    func testAlternativeLaws() {
        checkAlternativeLaws(for: [Int8].self, fabType: [ArrowOf<Int8, Int8>].self)
    }

    func testApplicativeLaws() {
        checkApplicativeLaws(for: [Int8].self, fabType: [ArrowOf<Int8, Int8>].self)
    }

    func testApplyLaws() {
        checkApplyLaws(for: [Int8].self, fabType: [ArrowOf<Int8, Int8>].self)
    }

    func testBindLaws() {
        checkBindLaws(for: [Int8].self)
    }

    func testFunctorLaws() {
        checkFunctorLaws(for: [Int8].self)
    }

    func testMonadLaws() {
        checkMonadLaws(for: [Int8].self)
    }

    func testMonadPlusLaws() {
        checkMonadPlusLaws(for: [Int8].self)
    }

    func testMonadZeroLaws() {
        checkMonadZeroLaws(for: [Int8].self)
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

    func testPlusLaws() {
        checkPlusLaws(for: [Int8].self)
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
