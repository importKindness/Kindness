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

/// Laws:
///
///     Left Identity: empty <|> x == x
///     Right Identity: x <|> empty == x
///     Annihilation: f <^> empty == empty

func plusLeftIdentityLaw<A: Arbitrary, F: Plus, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property {
    return forAll { (a: A) in
        let x = makeFunctor(a)

        let lhs: E = makeEquatable(F.empty <|> x)
        let rhs: E = makeEquatable(x)

        return lhs == rhs
    }
}

func plusRightIdentityLaw<A: Arbitrary, F: Plus, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property {
    return forAll { (a: A) in
        let x = makeFunctor(a)

        let lhs: E = makeEquatable(x <|> F.empty)
        let rhs: E = makeEquatable(x)

        return lhs == rhs
    }
}

func plusAnnihilationLaw<A: Arbitrary, F: Plus, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return forAll { (fArrow: ArrowOf<F.K1Arg, F.K1Arg>) in
        let f = fArrow.getArrow

        let lhs: E = makeEquatable(f <^> F.empty)
        let rhs: E = makeEquatable(F.empty)

        return lhs == rhs
    }
}

func checkPlusLaws<F: Plus & Arbitrary & Equatable>(for: F.Type) where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    let idF: (F) -> F = id

    property("Plus - Left Identity: empty <|> x == x")
        <- plusLeftIdentityLaw(makeFunctor: idF, makeEquatable: idF)

    property("Plus - Annihilation: f <^> empty = empty")
        <- plusRightIdentityLaw(makeFunctor: idF, makeEquatable: idF)

    property("Plus - Annihilation: f <^> empty = empty")
        <- plusAnnihilationLaw(makeFunctor: idF, makeEquatable: idF)
}

func plusLaws<A: Arbitrary, F: Plus, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return conjoin(
        plusLeftIdentityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable),
        plusRightIdentityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable),
        plusAnnihilationLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable)
    )
}
