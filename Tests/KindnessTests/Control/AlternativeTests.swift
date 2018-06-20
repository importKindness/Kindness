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

func alternativeDistributivityLaw<A: Arbitrary, F: Alternative, E: Equatable, B: Arbitrary, FAB: Alternative>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E,
    makeFAB: @escaping (B) -> FAB
) -> Property where
    F.K1Arg: Arbitrary & CoArbitrary & Hashable,
    F.K1Tag == FAB.K1Tag,
    FAB.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
        return forAll { (fArrows: B, gArrows: B, a: A) -> Bool in
            let xs = makeFunctor(a)

            let f = { $0.getArrow } <^> makeFAB(fArrows)
            let g = { $0.getArrow } <^> makeFAB(gArrows)

            let lhs: E = makeEquatable((f <|> g) <*> xs)

            let rhsL: F = f <*> xs
            let rhsR: F = g <*> xs
            let rhs: E = makeEquatable(rhsL <|> rhsR)

            return lhs == rhs
        }
}

func alternativeAnnihilationLaw<A: Arbitrary, F: Alternative, E: Equatable, FAB: Alternative>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E,
    fabType: FAB.Type
) -> Property where
    F.K1Arg: Arbitrary & CoArbitrary & Hashable,
    F.K1Tag == FAB.K1Tag,
    FAB.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
        return forAll { (a: A) -> Bool in
            let xs = makeFunctor(a)

            let emptyFs = { $0.getArrow } <^> FAB.empty

            let lhs: E = makeEquatable(emptyFs <*> xs)
            let rhs: E = makeEquatable(.empty)

            return lhs == rhs
        }
}

func checkAlternativeLaws<A: Alternative & Arbitrary & Equatable, FAB: Alternative & Arbitrary>(
    for: A.Type,
    fabType: FAB.Type
) where A.K1Arg: Arbitrary & CoArbitrary & Hashable, A.K1Tag == FAB.K1Tag, FAB.K1Arg == ArrowOf<A.K1Arg, A.K1Arg> {
    let idA: (A) -> A = id
    let idFAB: (FAB) -> FAB = id

    property("Alternative - Distributivity: (f <|> g) <*> x == (f <*> x) <|> (g <*> x)")
        <- alternativeDistributivityLaw(makeFunctor: idA, makeEquatable: idA, makeFAB: idFAB)

    property("Alternative - Annihilation: empty <*> f = empty")
        <- alternativeAnnihilationLaw(makeFunctor: idA, makeEquatable: idA, fabType: FAB.self)
}

func alternativeLaws<A: Arbitrary, F: Alternative, E: Equatable, B: Arbitrary, FAB: Alternative>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E,
    makeFAB: @escaping (B) -> FAB
) -> Property where
    F.K1Arg: Arbitrary & CoArbitrary & Hashable,
    F.K1Tag == FAB.K1Tag,
    FAB.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
        return conjoin(
            alternativeDistributivityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable, makeFAB: makeFAB),
            alternativeAnnihilationLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable, fabType: FAB.self)
        )
}
