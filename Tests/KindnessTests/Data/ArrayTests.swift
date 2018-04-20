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
    func testFunctorPreservesIdentity() {
        property("functor preserves identity") <- forAll { (xs: [Int]) in
            return (id <^> xs) == (id <| xs)
        }
    }

    func testFunctorPreservesComposition() {
        property("functor preserves composition")
            <- forAll { (xs: [Int], fArrow: ArrowOf<Int, UInt>, gArrow: ArrowOf<UInt, String>) in
                let f = fArrow.getArrow
                let g = gArrow.getArrow
                return (g • f <^> xs) == (fmap(g) • fmap(f) <| xs)
            }
    }
}
