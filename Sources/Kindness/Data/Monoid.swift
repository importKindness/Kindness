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

public protocol Monoid: Semigroup {
    static var mempty: Self { get }
}

public func power<M: Monoid, N: FixedWidthInteger>(_ m: M, _ p: N) -> M {
    switch p {
    case N.min...0:
        return .mempty

    case 1:
        return m

    case 2...N.max where p % 2 == 0:
        let x = power(m, p / 2)
        return x <> x

    default:
        let x = power(m, p / 2)
        return x <> x <> m
    }
}
