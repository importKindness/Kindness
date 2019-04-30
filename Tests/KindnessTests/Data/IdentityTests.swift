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
import SwiftCheckKindness

class IdentityTests: XCTestCase {
    func testAltLaws() {
        checkAltLaws(for: Identity<Int8>.self)
    }

    func testApplicativeLaws() {
        checkApplicativeLaws(for: Identity<Int8>.self, fabType: Identity<ArrowOf<Int8, Int8>>.self)
    }

    func testApplyLaws() {
        checkApplyLaws(for: Identity<Int8>.self, fabType: Identity<ArrowOf<Int8, Int8>>.self)
    }

    func testBindLaws() {
        checkBindLaws(for: Identity<Int8>.self)
    }

    func testExtendLaws() {
        checkExtendLaws(for: Either<UInt8, Int8>.self)
    }

    func testFunctorLaws() {
        checkFunctorLaws(for: Identity<Int8>.self)
    }

    func testMonadLaws() {
        checkMonadLaws(for: Identity<Int8>.self)
    }
}
