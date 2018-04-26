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

infix operator <>: AdditionPrecedence

/// A type with an associative binary operation
public protocol Semigroup {
    /// Append the value on the right to the value on the left
    ///
    /// - Parameters:
    ///   - lhs: Value to which `rhs` should be appended
    ///   - rhs: Value to append to `lhs`
    /// - Returns: Result of appending `rhs` to `lhs`
    static func <> (_ lhs: Self, _ rhs: Self) -> Self
}
