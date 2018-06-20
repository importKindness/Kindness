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

func monadZeroAnnihilationLaw<A: Arbitrary, M: MonadZero, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property where M.K1Arg: CoArbitrary & Hashable {
    return forAll { (fArrow: ArrowOf<M.K1Arg, A>) -> Bool in
        let f = makeMonad • fArrow.getArrow

        let lhs: E = makeEquatable(M.empty >>- f)
        let rhs: E = makeEquatable(M.empty)

        return lhs == rhs
    }
}

func checkMonadZeroLaws<M: MonadZero & Arbitrary & Equatable>(for: M.Type) where M.K1Arg: CoArbitrary & Hashable {
    let idM: (M) -> M = id

    property("MonadZero - Annihilation: empty >>- f = empty")
        <- monadZeroAnnihilationLaw(makeMonad: idM, makeEquatable: idM)
}

func monadZeroLaws<A: Arbitrary, M: MonadZero, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property where M.K1Arg: CoArbitrary & Hashable {
    return monadZeroAnnihilationLaw(makeMonad: makeMonad, makeEquatable: makeEquatable)
}
