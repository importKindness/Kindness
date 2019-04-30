// Copyright © 2019 the Kindness project contributors. All rights reserved.
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

extension Either: Arbitrary where L: Arbitrary, R: Arbitrary {
    public static var arbitrary: Gen<Either<L, R>> {
        return Gen.one(of: [
            L.arbitrary.map(Either<L, R>.left),
            R.arbitrary.map(Either<L, R>.right)
        ])
    }

    public static func shrink(_ x: Either<L, R>) -> [Either<L, R>] {
        switch x {
        case .left(let l):
            return L.shrink(l).map(Either<L, R>.left)

        case .right(let r):
            return R.shrink(r).map(Either<L, R>.right)
        }
    }
}

extension Either: CoArbitrary where L: CoArbitrary, R: CoArbitrary {
    public static func coarbitrary<C>(_ x: Either<L, R>) -> ((Gen<C>) -> Gen<C>) {
        switch x {
        case .left(let l):
            return L.coarbitrary(l)

        case .right(let r):
            return R.coarbitrary(r)
        }
    }
}
