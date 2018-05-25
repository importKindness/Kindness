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

private func functorIdentityLaw<A: Arbitrary, F: Functor, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property {
    return forAll { (a: A) -> Bool in
        let xs = makeFunctor(a)

        let lhs = makeEquatable(id <^> xs)
        let rhs = makeEquatable(id <| xs)

        return lhs == rhs
    }
}

private func functorCompositionLaw<A: Arbitrary, F: Functor, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return forAll { (a: A, fArrow: ArrowOf<F.K1Arg, F.K1Arg>, gArrow: ArrowOf<F.K1Arg, F.K1Arg>) -> Bool in
        let xs = makeFunctor(a)

        let f = fArrow.getArrow
        let g = gArrow.getArrow

        let lhs = makeEquatable(fmap(f <<< g, xs))
        let rhs = makeEquatable(((fmap <| f) <<< (fmap <| g)) <| xs)

        return lhs == rhs
    }
}

func checkFunctorLaws<F: Functor & Arbitrary & Equatable>(
    for: F.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    let idF: (F) -> F = id

    property("\(F.self): Functor - Identity: fmap(id) == id")
        <- functorIdentityLaw(makeFunctor: idF, makeEquatable: idF)

    property("\(F.self): Functor - Composition: fmap(f <<< g) = fmap(f) <<< fmap(g))")
        <- functorCompositionLaw(makeFunctor: idF, makeEquatable: idF)
}

func functorLaws<A: Arbitrary, F: Functor, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return conjoin(
        functorIdentityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable),
        functorCompositionLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable)
    )
}
