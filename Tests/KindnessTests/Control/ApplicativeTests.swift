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

func checkApplicativeIdentityLaw<F: Applicative & Arbitrary & Equatable>(for: F.Type) {
    property("Applicative - Identity: pure(id) <*> v == v")
        <- forAll { (xs: F) -> Bool in
            return (pure(id) <*> xs) == xs
        }
}

func checkApplicativeCompositionLaw<F: Applicative & Arbitrary & Equatable, G: Applicative & Arbitrary>(
    for: F.Type, fabType: G.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable, F.K1Tag == G.K1Tag, G.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
    property("Applicative - Composition: pure(<<<) <*> f <*> g <*> h == f <*> (g <*> h)")
        <- forAll { (fArrows: G, gArrows: G, h: F) -> Bool in
            let f = { $0.getArrow } <^> fArrows
            let g = { $0.getArrow } <^> gArrows

            let lhs: F = pure(curry(•)) <*> f <*> g <*> h
            let rhs: F = f <*> (g <*> h)

            return lhs == rhs
        }
}

func checkApplicativeHomomorphismLaw<F: Applicative & Arbitrary & Equatable>(
    for: F.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable {
    property("Applicative - Homomorphism: pure(f) <*> pure(x) == pure(f(x))")
        <- forAll { (fArrow: ArrowOf<F.K1Arg, F.K1Arg>, x: F.K1Arg) -> Bool in
            let f = fArrow.getArrow

            let lhs: F = pure(f) <*> (pure(x) as F)
            let rhs: F = pure(f(x))

            return lhs == rhs
        }
}

func checkApplicativeInterchangeLaw<F: Applicative & Arbitrary & Equatable, G: Applicative & Arbitrary>(
    for: F.Type, fabType: G.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable, F.K1Tag == G.K1Tag, G.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
    property("Applicative - Interchange: u <*> pure(y) == pure ((|>) y) <*> u")
        <- forAll { (fArrows: G, x: F.K1Arg) -> Bool in
            let f = { $0.getArrow } <^> fArrows

            let lhs: F = f <*> pure(x)
            let rhs: F = pure(curry(|>)(x)) <*> f

            return lhs == rhs
        }
}

func checkApplicativeLaws<F: Applicative & Arbitrary & Equatable, G: Applicative & Arbitrary>(
    for: F.Type, fabType: G.Type
) where F.K1Arg: Arbitrary & CoArbitrary & Hashable, F.K1Tag == G.K1Tag, G.K1Arg == ArrowOf<F.K1Arg, F.K1Arg> {
    checkApplicativeIdentityLaw(for: F.self)
    checkApplicativeCompositionLaw(for: F.self, fabType: G.self)
    checkApplicativeHomomorphismLaw(for: F.self)
    checkApplicativeInterchangeLaw(for: F.self, fabType: G.self)
}
