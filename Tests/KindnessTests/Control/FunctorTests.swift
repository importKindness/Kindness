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

func checkFunctorIdentityLaw<F: Functor & Arbitrary & Equatable>(for: F.Type) {
    property("Functor - Identity: fmap(id) == id")
        <- forAll { (xs: F) -> Bool in
            return (id <^> xs) == (id <| xs)
        }
}

func checkFunctorCompositionLaw<F: Functor & Arbitrary & Equatable>(
    for: F.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    property("Functory - Composition: fmap(f <<< g) = fmap(f) <<< fmap(g))")
        <- forAll { (xs: F, fArrow: ArrowOf<F.K1Arg, F.K1Arg>, gArrow: ArrowOf<F.K1Arg, F.K1Arg>) -> Bool in
            let f = fArrow.getArrow
            let g = gArrow.getArrow

            let lhs: F = fmap(f <<< g, xs)
            let rhs: F = ((fmap <| f) <<< (fmap <| g)) <| xs

            return lhs == rhs
        }
}

func checkFunctorLaws<F: Functor & Arbitrary & Equatable>(
    for: F.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    checkFunctorIdentityLaw(for: F.self)
    checkFunctorCompositionLaw(for: F.self)
}
