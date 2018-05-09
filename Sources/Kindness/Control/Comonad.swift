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

/// HKT tag for `Comonad`s
public protocol ComonadTag: DuplicateTag, ExtendTag {

    /// `_extract` implementation for the tagged `Comonad`.
    static func _extract<A>(_ w: KindApplication<Self, A>) -> A
}

/// Combines `Duplicate` and `Extend` with the ability to extract a value from the context.
///
/// Laws:
///
///     Left Identity: extract <<- xs = xs
///     Right Identity: extract (f <<- xs) = f xs
public protocol Comonad: Duplicate, Extend {

    /// Extract a value from context.
    ///
    /// - Returns: The extracted value.
    func _extract() -> K1Arg
}

/// Extract a value from context.
///
/// - Parameter w: `F<A>` a value in context.
/// - Returns: The extracted value.
public func extract<W: Comonad>(_ w: W) -> W.K1Arg {
    return w._extract()
}

/// Extract a value from context.
///
/// - Parameter w: `F<A>` a value in context.
/// - Returns: The extracted value.
public func extract<FTag: ComonadTag, A>(_ w: KindApplication<FTag, A>) -> A {
    return FTag._extract(w)
}

public protocol ComonadByDuplicate: Duplicate { }

public extension ComonadByDuplicate {
    func _extend<B>(_ f: @escaping (K1Self) -> B) -> KindApplication<K1Tag, B> {
        return f <^> K1Tag._duplicate(self.kind)
    }
}

/// Provides a default implementation for `_duplicate` based on `_extend`.
public protocol ComonadByExtend: Extend { }

public extension ComonadByExtend {
    static func _duplicate(_ w: K1Self) -> KindApplication<K1Tag, K1Self> {
        return K1Tag._extend(id, w)
    }
}
