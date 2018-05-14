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

import SwiftCheck

import Kindness

func checkAlternativeDistributivityLaw<A: Alternative & Arbitrary & Equatable, FAB: Alternative & Arbitrary>(
    for: A.Type,
    fabType: FAB.Type
) where A.K1Arg: Arbitrary & CoArbitrary & Hashable, A.K1Tag == FAB.K1Tag, FAB.K1Arg == ArrowOf<A.K1Arg, A.K1Arg> {
    property("Alternative - Distributivity: (f <|> g) <*> x == (f <*> x) <|> (g <*> x)")
        <- forAll { (fArrows: FAB, gArrows: FAB, xs: A) -> Bool in
            let f = { $0.getArrow } <^> fArrows
            let g = { $0.getArrow } <^> gArrows

            let lhs: A = (f <|> g) <*> xs

            let rhsL: A = f <*> xs
            let rhsR: A = g <*> xs
            let rhs: A = rhsL <|> rhsR

            return lhs == rhs
        }
}

func checkAlternativeAnnihilationLaw<A: Alternative & Arbitrary & Equatable, FAB: Alternative>(
    for: A.Type, fabType: FAB.Type
) where A.K1Tag == FAB.K1Tag, FAB.K1Arg == ArrowOf<A.K1Arg, A.K1Arg> {
    property("Alternative - Annihilation: empty <*> f = empty")
        <- forAll { (xs: A) -> Bool in
            let emptyFs = { $0.getArrow } <^> FAB.empty

            let lhs: A = emptyFs <*> xs
            let rhs: A = .empty

            return lhs == rhs
        }
}

func checkAlternativeLaws<A: Alternative & Arbitrary & Equatable, FAB: Alternative & Arbitrary>(
    for: A.Type,
    fabType: FAB.Type
) where A.K1Arg: Arbitrary & CoArbitrary & Hashable, A.K1Tag == FAB.K1Tag, FAB.K1Arg == ArrowOf<A.K1Arg, A.K1Arg> {
    checkAlternativeDistributivityLaw(for: A.self, fabType: FAB.self)
    checkAlternativeAnnihilationLaw(for: A.self, fabType: FAB.self)
}
