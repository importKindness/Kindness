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

infix operator •: CompositionPrecedenceRight

/// Compose two functions to make a single function: "g after" f"
///
/// - Parameters:
///   - g: Function to perform second
///   - f: Function to perform first
/// - Returns: Function from input of `f` to output of `g` that calls "g after f"
public func •<A, B, C>(_ g: @escaping (B) -> C, _ f: @escaping (A) -> B) -> (A) -> C {
    return { g(f($0)) }
}

infix operator |>: ApplyPrecedenceLeft

/// Applies the argument on the left to the function on the right
///
/// - Parameters:
///   - a: Argument to apply
///   - f: Function to call
/// - Returns: Result of calling `f` with `a`
public func |> <A, B> (_ a: A, _ f: (A) -> B) -> B {
    return f(a)
}

infix operator <|: ApplyPrecedenceRight

/// Applies the argument on the right to the function on the left
///
/// - Parameters:
///   - f: Function to call
///   - a: Argument to apply
/// - Returns: Result of calling `f` with `a`
public func <| <A, B> (_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}

/// Returns the value passed in unchanged
///
/// - Parameter a: a value
/// - Returns: The same value `a`
public func id<A>(_ a: A) -> A {
    return a
}
