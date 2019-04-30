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

public func bindAssociativityLaw<A: Arbitrary, F: Bind, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: CoArbitrary & Hashable {
    return forAll { (a: A, fArrow: ArrowOf<F.K1Arg, A>, gArrow: ArrowOf<F.K1Arg, A>) -> Bool in
        let xs = makeFunctor(a)

        let f = makeFunctor • fArrow.getArrow
        let g = makeFunctor • gArrow.getArrow

        let lhs: E = makeEquatable((xs >>- f) >>- g)
        let rhs: E = makeEquatable(xs >>- { k -> F in f(k) >>- g })

        return lhs == rhs
    }
}

public func checkBindLaws<F: Bind & Arbitrary & Equatable>(for: F.Type) where F.K1Arg: CoArbitrary & Hashable {
    let idF: (F) -> F = id

    property("Bind - Associativity: (x >>- f) >>- g = x >>- { k in f(k) >>- g }")
        <- bindAssociativityLaw(makeFunctor: idF, makeEquatable: idF)
}

public func bindLaws<A: Arbitrary, F: Bind, E: Equatable>(
    makeFunctor: @escaping (A) -> F,
    makeEquatable: @escaping (F) -> E
) -> Property where F.K1Arg: CoArbitrary & Hashable {
    return bindAssociativityLaw(makeFunctor: makeFunctor, makeEquatable: makeEquatable)
}
