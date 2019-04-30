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

public func monadLeftIdentityLaw<A: Arbitrary, M: Monad, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property where M.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return forAll { (x: M.K1Arg, fArrow: ArrowOf<M.K1Arg, A>) in
        let f = makeMonad • fArrow.getArrow

        let lhs: E = makeEquatable(pure(x) >>- f)
        let rhs: E = makeEquatable(f(x))

        return lhs == rhs
    }
}

public func monadRightIdentityLaw<A: Arbitrary, M: Monad, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property {
    return forAll { (a: A) in
        let x = makeMonad(a)

        let lhs: E = makeEquatable(x >>- pure)
        let rhs: E = makeEquatable(x)

        return lhs == rhs
    }
}

public func checkMonadLaws<M: Monad & Arbitrary & Equatable>(for: M.Type) where M.K1Arg: Arbitrary & CoArbitrary & Hashable {
    let idM: (M) -> M = id

    property("\(M.self) - Monad - Left Identity: pure(x) >>- f == f(x)")
        <- monadLeftIdentityLaw(makeMonad: idM, makeEquatable: idM)

    property("\(M.self) - Monad - Right Identity: x >>- pure == x")
        <- monadRightIdentityLaw(makeMonad: idM, makeEquatable: idM)
}

public func monadLaws<A: Arbitrary, M: Monad, E: Equatable>(
    makeMonad: @escaping (A) -> M,
    makeEquatable: @escaping (M) -> E
) -> Property where M.K1Arg: Arbitrary & CoArbitrary & Hashable {
    return conjoin(
        monadLeftIdentityLaw(makeMonad: makeMonad, makeEquatable: makeEquatable),
        monadRightIdentityLaw(makeMonad: makeMonad, makeEquatable: makeEquatable)
    )
}
