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

/// HKT tag for types conforming to `Plus`
public protocol PlusTag: AltTag {
    /// Empty value of the tagged `Plus` as a `KindApplication`
    static func empty<A>() -> KindApplication<Self, A>
}

/// `Alt` with an empty value. Appending the empty value should return the original value. Appending a value to the
/// empty value should return the appended value.
///
/// Laws:
///
///     Left Identity: empty <|> x == x
///     Right Identity: x <|> empty == x
///     Annihilation: f <^> empty == empty
public protocol Plus: Alt where K1Tag: PlusTag {

    /// Empty value of `Self`. Appending this value to another value should return the original value. Appending another
    /// value to this value should return the appended value.
    static var empty: Self { get }
}
