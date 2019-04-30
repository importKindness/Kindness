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

public func applyAssociativeCompositionLaw<A: Arbitrary, F: Apply, E: Equatable, B: Arbitrary, FAB: Apply>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E,
    makeFAB: @escaping (B) -> FAB
) -> Property where
    F.K1Arg: Arbitrary & CoArbitrary & Hashable,
    F.K1Tag == FAB.K1Tag,
    FAB.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
        return forAll { (fArrows: B, gArrows: B, a: A) -> Bool in
            let h = makeFunctor(a)

            let f = { $0.getArrow } <^> makeFAB(fArrows)
            let g = { $0.getArrow } <^> makeFAB(gArrows)

            let lhs: E = makeEquatable(curry(<<<) <^> f <*> g <*> h)
            let rhs: E = makeEquatable(f <*> (g <*> h))

            return lhs == rhs
        }
}

public func checkApplyLaws<F: Apply & Arbitrary & Equatable, FAB: Apply & Arbitrary>(
    for: F.Type, fabType: FAB.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable, F.K1Tag == FAB.K1Tag, FAB.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
    let idF: (F) -> F = id
    let idFAB: (FAB) -> (FAB) = id

    property("\(F.self): Apply - Associative composition: (<<<) <^> f <*> g <*> h == f <*> (g <*> h)")
        <- applyAssociativeCompositionLaw(makeFunctor: idF, makeEquatable: idF, makeFAB: idFAB)
}

public func applyLaws<A: Arbitrary, F: Apply, E: Equatable, B: Arbitrary, FAB: Apply>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E,
    makeFAB: @escaping (B) -> FAB
) -> Property where
    F.K1Arg: Arbitrary & CoArbitrary & Hashable,
    F.K1Tag == FAB.K1Tag,
    FAB.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
        return applyAssociativeCompositionLaw(
            makeFunctor: makeFunctor,
            makeEquatable: makeEquatable,
            makeFAB: makeFAB
        )
}
