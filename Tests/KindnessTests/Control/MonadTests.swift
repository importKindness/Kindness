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

func checkMonadLeftIdentityLaw<M: Monad & Arbitrary & Equatable>(
    for: M.Type
) where M.K1Arg: Arbitrary & CoArbitrary & Hashable {
    property("\(M.self) - Monad - Left Identity: pure(x) >>- f == f(x)")
        <- forAll { (x: M.K1Arg, fArrow: ArrowOf<M.K1Arg, M>) in
            let f = fArrow.getArrow

            let lhs: M = pure(x) >>- f
            let rhs: M = f(x)

            return lhs == rhs
        }
}

func checkMonadRightIdentityLaw<M: Monad & Arbitrary & Equatable>(for: M.Type) {
    property("\(M.self) - Monad - Right Identity: x >>- pure == x")
        <- forAll { (x: [Int8]) in
            return (x >>- pure) == x
        }
}

func checkMonadLaws<M: Monad & Arbitrary & Equatable>(for: M.Type) where M.K1Arg: Arbitrary & CoArbitrary & Hashable {
    checkMonadLeftIdentityLaw(for: M.self)
    checkMonadRightIdentityLaw(for: M.self)
}
