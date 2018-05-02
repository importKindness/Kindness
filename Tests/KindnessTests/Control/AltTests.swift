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

func checkAltAssociativityLaw<A: Alt & Arbitrary & Equatable>(for: A.Type) {
    property("Alt - Associativity: (x <|> y) <|> z == x <|> (y <|> z)")
        <- forAll { (x: A, y: A, z: A) -> Bool in
            return ((x <|> y) <|> z) == (x <|> (y <|> z))
        }
}

func checkAltDistributivity<A: Alt & Arbitrary & Equatable>(
    for: A.Type
) where A.K1Arg: CoArbitrary & Arbitrary & Hashable {
    property("Alt - Distributivity: f <^> (x <|> y) == (f <^> x) <|> (f <^> y)")
        <- forAll { (x: A, y: A, fArrow: ArrowOf<A.K1Arg, A.K1Arg>) -> Bool in
            let f = fArrow.getArrow

            let lhs: A = f <^> (x <|> y)
            let rhs: A = (f <^> x) <|> (f <^> y)

            return lhs == rhs
        }
}

func checkAltLaws<A: Alt & Arbitrary & Equatable>(for: A.Type) where A.K1Arg: CoArbitrary & Arbitrary & Hashable {
    checkAltAssociativityLaw(for: A.self)
    checkAltDistributivity(for: A.self)
}
