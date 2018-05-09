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

func checkBindAssociativityLaw<F: Bind & Arbitrary & Equatable>(for: F.Type) where F.K1Arg: CoArbitrary & Hashable {
    property("Bind - Associativity: (x >>- f) >>- g = x >>- { k in f(k) >>- g }")
        <- forAll { (xs: F, fArrow: ArrowOf<F.K1Arg, F>, gArrow: ArrowOf<F.K1Arg, F>) -> Bool in
            let f = fArrow.getArrow
            let g = gArrow.getArrow

            let lhs: F = (xs >>- f) >>- g
            let rhs: F = xs >>- { k -> F in f(k) >>- g }

            return lhs == rhs
        }
}

func checkBindLaws<F: Bind & Arbitrary & Equatable>(for: F.Type) where F.K1Arg: CoArbitrary & Hashable {
    checkBindAssociativityLaw(for: F.self)
}
