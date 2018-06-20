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

private func makeEquatable(with e: UInt8) -> (ReaderT<UInt8, Identity<Int8>>) -> Identity<Int8> {
    return { reader in
        return reader.runReaderT(e)
    }
}

private func makeEquatable(with e: UInt8) -> (ReaderT<UInt8, [Int8]>) -> [Int8] {
    return { reader in
        return reader.runReaderT(e)
    }
}

class ReaderTTests: XCTestCase {
    func testAlternativeLaws() {
        property("ReaderT obeys Alternative laws")
            <- forAll { (e: UInt8) in
                return alternativeLaws(
                    makeFunctor: ReaderTOf<UInt8, [Int8]>.makeReaderT,
                    makeEquatable: makeEquatable(with: e),
                    makeFAB: ReaderTOf<UInt8, [ArrowOf<Int8, Int8>]>.makeReaderT
                )
            }
    }

    func testAltLaws() {
        property("ReaderT obeys Alt laws")
            <- forAll { (e: UInt8) in
                return altLaws(
                    makeFunctor: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }

    func testApplicativeLaws() {
        property("ReaderT obeys Applicative laws")
            <- forAll { (e: UInt8) in
                return applicativeLaws(
                    makeFunctor: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: makeEquatable(with: e),
                    makeFAB: ReaderTOf<UInt8, Identity<ArrowOf<Int8, Int8>>>.makeReaderT
                )
            }
    }

    func testApplyLaws() {
        property("ReaderT obeys Apply laws")
            <- forAll { (e: UInt8) in
                return applyLaws(
                    makeFunctor: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: makeEquatable(with: e),
                    makeFAB: ReaderTOf<UInt8, Identity<ArrowOf<Int8, Int8>>>.makeReaderT
                )
            }
    }

    func testBindLaws() {
        property("ReaderT obeys Apply laws")
            <- forAll { (e: UInt8) in
                return bindLaws(
                    makeFunctor: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }

    func testFunctorLaws() {
        property("ReaderT obeys Functor laws")
            <- forAll { (e: UInt8) in
                return functorLaws(
                    makeFunctor: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }

    func testMonadLaws() {
        property("ReaderT obeys Monad laws")
            <- forAll { (e: UInt8) in
                return monadLaws(
                    makeMonad: ReaderTOf<UInt8, Identity<Int8>>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }

    func testMonadPlusLaws() {
        property("ReaderT obeys MonadPlus laws")
            <- forAll { (e: UInt8) in
                return monadPlusLaws(
                    makeMonad: ReaderTOf<UInt8, [Int8]>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }

    func testMonadZeroLaws() {
        property("ReaderT obeys MonadZero laws")
            <- forAll { (e: UInt8) in
                return monadZeroLaws(
                    makeMonad: ReaderTOf<UInt8, [Int8]>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }

    func testPlusLaws() {
        property("ReaderT obeys Plus laws")
            <- forAll { (e: UInt8) in
                return plusLaws(
                    makeFunctor: ReaderTOf<UInt8, [Int8]>.makeReaderT,
                    makeEquatable: makeEquatable(with: e)
                )
            }
    }
}
