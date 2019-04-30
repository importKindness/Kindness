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

public struct ReaderTOf<Environment: CoArbitrary & Hashable, M: Monad & Arbitrary> {
    public let readerT: ReaderT<Environment, M>
    public let arrow: ArrowOf<Environment, M>

    public init(_ arrow: ArrowOf<Environment, M>) {
        self.readerT = ReaderT<Environment, M>(arrow.getArrow)
        self.arrow = arrow
    }

    public static func makeReaderT(_ of: ReaderTOf<Environment, M>) -> ReaderT<Environment, M> {
        return of.readerT
    }
}

extension ReaderTOf: Arbitrary where Environment: CoArbitrary & Hashable, M: Arbitrary {
    public static var arbitrary: Gen<ReaderTOf<Environment, M>> {
        return ArrowOf<Environment, M>.arbitrary.map(ReaderTOf.init)
    }

    public static func shrink(_ x: ReaderTOf<Environment, M>) -> [ReaderTOf<Environment, M>] {
        return ArrowOf<Environment, M>.shrink(x.arrow).map(ReaderTOf.init)
    }
}
