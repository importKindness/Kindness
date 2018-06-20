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

func altAssociativityLaw<A: Arbitrary, F: Alt, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property {
    return forAll { (ax: A, ay: A, az: A) -> Bool in
        let x = makeFunctor(ax)
        let y = makeFunctor(ay)
        let z = makeFunctor(az)

        let lhs: E = makeEquatable((x <|> y) <|> z)
        let rhs: E = makeEquatable(x <|> (y <|> z))

        return lhs == rhs
    }
}

func altDistributivityLaw<A: Arbitrary, F: Alt, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return forAll { (ax: A, ay: A, fArrow: ArrowOf<F.K1Arg, F.K1Arg>) -> Bool in
        let x = makeFunctor(ax)
        let y = makeFunctor(ay)

        let f = fArrow.getArrow

        let lhs: E = makeEquatable(f <^> (x <|> y))
        let rhs: E = makeEquatable((f <^> x) <|> (f <^> y))

        return lhs == rhs
    }
}

func checkAltLaws<A: Alt & Arbitrary & Equatable>(for: A.Type) where A.K1Arg: CoArbitrary & Arbitrary & Hashable {
    let idA: (A) -> A = id

    property("Alt - Associativity: (x <|> y) <|> z == x <|> (y <|> z)")
        <- altAssociativityLaw(makeFunctor: idA, makeEquatable: idA)

    property("Alt - Distributivity: f <^> (x <|> y) == (f <^> x) <|> (f <^> y)")
        <- altDistributivityLaw(makeFunctor: idA, makeEquatable: idA)
}

func altLaws<A: Arbitrary, F: Alt, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return conjoin(
        altAssociativityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable),
        altDistributivityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable)
    )
}
