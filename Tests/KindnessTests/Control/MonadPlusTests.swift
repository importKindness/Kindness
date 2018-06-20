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

func monadPlusDistributivityLaw<A: Arbitrary, M: MonadPlus, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property where M.K1Arg: CoArbitrary & Hashable {
    return forAll { (a: A, b: A, fArrow: ArrowOf<M.K1Arg, A>) -> Bool in
        let x = makeMonad(a)
        let y = makeMonad(b)

        let f = makeMonad • fArrow.getArrow

        let lhs: E = makeEquatable((x <|> y) >>- f)
        let rhs: E = makeEquatable((x >>- f) <|> (y >>- f))

        return lhs == rhs
    }
}

func checkMonadPlusLaws<M: MonadPlus & Arbitrary & Equatable>(for: M.Type) where M.K1Arg: CoArbitrary & Hashable {
    let idM: (M) -> M = id

    property("MonadPlus - Distributivity: (x <|> y) >>- f == (x >>- f) <|> (y >>- f)")
        <- monadPlusDistributivityLaw(makeMonad: idM, makeEquatable: idM)
}

func monadPlusLaws<A: Arbitrary, M: MonadPlus, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property where M.K1Arg: CoArbitrary & Hashable {
    return monadPlusDistributivityLaw(makeMonad: makeMonad, makeEquatable: makeEquatable)
}
