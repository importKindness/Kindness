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

#if !os(macOS)

extension ArrayTests {
    static var allTests: [(String, (ArrayTests) -> () throws -> Void)] = [
        ("testAltLaws", testAltLaws),
        ("testAlternativeLaws", testAlternativeLaws),
        ("testApplicativeLaws", testApplicativeLaws),
        ("testApplyLaws", testApplyLaws),
        ("testBindLaws", testBindLaws),
        ("testEmptyEqualsMempty", testEmptyEqualsMempty),
        ("testFunctorLaws", testFunctorLaws),
        ("testMonadLaws", testMonadLaws),
        ("testMonadPlusLaws", testMonadPlusLaws),
        ("testMonadZeroLaws", testMonadZeroLaws),
        ("testMonoidLeftIdentity", testMonoidLeftIdentity),
        ("testMonoidRightIdentity", testMonoidRightIdentity),
        ("testPlusLaws", testPlusLaws),
        ("testSemigroupAssociativity", testSemigroupAssociativity)
    ]
}

extension EitherTests {
    static var allTests: [(String, (EitherTests) -> () throws -> Void)] = [
        ("testAltLaws", testAltLaws),
        ("testApplicativeLaws", testApplicativeLaws),
        ("testApplyLaws", testApplyLaws),
        ("testBindLaws", testBindLaws),
        ("testExtendLaws", testExtendLaws),
        ("testFunctorLaws", testFunctorLaws),
        ("testMonadLaws", testMonadLaws)
    ]
}

extension IdentityTests {
    static var allTests: [(String, (IdentityTests) -> () throws -> Void)] = [
        ("testAltLaws", testAltLaws),
        ("testApplicativeLaws", testApplicativeLaws),
        ("testApplyLaws", testApplyLaws),
        ("testBindLaws", testBindLaws),
        ("testExtendLaws", testExtendLaws),
        ("testFunctorLaws", testFunctorLaws),
        ("testMonadLaws", testMonadLaws)
    ]
}

extension MonoidTests {
    static var allTests: [(String, (MonoidTests) -> () throws -> Void)] = [
        ("testPowerRepeatsMonoidProvidedNumberOfTimes", testPowerRepeatsMonoidProvidedNumberOfTimes)
    ]
}

extension ReaderTTests {
    static var allTests: [(String, (ReaderTTests) -> () throws -> Void)] = [
        ("testAlternativeLaws", testAlternativeLaws),
        ("testAltLaws", testAltLaws),
        ("testApplicativeLaws", testApplicativeLaws),
        ("testApplyLaws", testApplyLaws),
        ("testBindLaws", testBindLaws),
        ("testFunctorLaws", testFunctorLaws),
        ("testMonadLaws", testMonadLaws),
        ("testMonadPlusLaws", testMonadPlusLaws),
        ("testMonadZeroLaws", testMonadZeroLaws),
        ("testPlusLaws", testPlusLaws)
    ]
}

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArrayTests.allTests),
        testCase(EitherTests.allTests),
        testCase(IdentityTests.allTests),
        testCase(MonoidTests.allTests),
        testCase(ReaderTTests.allTests)
    ]
}
#endif
