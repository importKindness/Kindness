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

func checkApplyAssociativeCompositionLaw<F: Apply & Arbitrary & Equatable, G: Apply & Arbitrary>(
    for: F.Type, fabType: G.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable, F.K1Tag == G.K1Tag, G.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
    property("Apply - Associative composition: (<<<) <^> f <*> g <*> h == f <*> (g <*> h)")
        <- forAll { (fArrows: G, gArrows: G, h: F) -> Bool in
            let f = { $0.getArrow } <^> fArrows
            let g = { $0.getArrow } <^> gArrows

            let lhs: F = curry(<<<) <^> f <*> g <*> h
            let rhs: F = f <*> (g <*> h)

            return lhs == rhs
        }
}

func checkApplyLaws<F: Apply & Arbitrary & Equatable, G: Apply & Arbitrary>(
    for: F.Type, fabType: G.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable, F.K1Tag == G.K1Tag, G.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
    return checkApplyAssociativeCompositionLaw(for: F.self, fabType: G.self)
}
