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

import XCTest

import SwiftCheck

import Kindness

struct ReaderTOf<Environment: CoArbitrary & Hashable, M: Monad & Arbitrary> {
    let readerT: ReaderT<Environment, M>
    let arrow: ArrowOf<Environment, M>

    init(_ arrow: ArrowOf<Environment, M>) {
        self.readerT = ReaderT<Environment, M>(arrow.getArrow)
        self.arrow = arrow
    }

    static func makeReaderT(_ of: ReaderTOf<Environment, M>) -> ReaderT<Environment, M> {
        return of.readerT
    }
}

extension ReaderTOf: Arbitrary where Environment: CoArbitrary & Hashable, M: Arbitrary {
    static var arbitrary: Gen<ReaderTOf<Environment, M>> {
        return ArrowOf<Environment, M>.arbitrary.map(ReaderTOf.init)
    }

    static func shrink(_ x: ReaderTOf<Environment, M>) -> [ReaderTOf<Environment, M>] {
        return ArrowOf<Environment, M>.shrink(x.arrow).map(ReaderTOf.init)
    }
}

class ReaderTTests: XCTestCase {
    func testFunctorLaws() {
        property("ReaderT obeys Functor laws")
            <- forAll { (e: UInt8) in
                func run(_ reader: ReaderT<UInt8, Identity<Int8>>) -> Identity<Int8> {
                    return reader.run(e)
                }

                return functorLaws(
                    makeFunctor: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: run
                )
            }
    }
}
