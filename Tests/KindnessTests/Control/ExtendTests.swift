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

func checkExtendAssociativityLaw<E: Extend & Arbitrary & CoArbitrary & Hashable>(
    for: E.Type
) where E.K1Arg: Arbitrary & Hashable {
    property("Extend - Associativity: extend f <<< extend g = extend (f <<< extend g)")
        <- forAll { (x: E, fArrow: ArrowOf<E, E.K1Arg>, gArrow: ArrowOf<E, E.K1Arg>) -> Bool in
            let f = fArrow.getArrow
            let g = gArrow.getArrow

            let lhs: E = (extend <| f) <<< (extend <| g) <| x
            let rhs: E = (extend <| (f <<< (extend <| g))) <| x

            return lhs == rhs
        }
}

func checkExtendLaws<E: Extend & Arbitrary & CoArbitrary & Hashable>(for: E.Type) where E.K1Arg: Arbitrary & Hashable {
    checkExtendAssociativityLaw(for: E.self)
}
