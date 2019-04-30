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

/// HKT tag protocol for types conforming to `MonadTrans`
public protocol MonadTransTag {
    associatedtype MTag: MonadTag
}

/// Protocol for monad transformers. Can be used to embellish an existing monad with additional capabilities.
///
/// Laws:
///
///     Identity: lift(pure(a)) == pure(a)
///     Bind Distributivity: lift(m >>- f) == lift(m) >>- (lift • f)
public protocol MonadTrans: K2 where K2Tag: MonadTransTag, K2Arg == K1Tag, K2Tag.MTag == K1Tag {

    /// Lifts a Monad into a transformed Monad that adds the effects of `Self`.
    ///
    /// - Parameter m: Monad to lift
    /// - Returns: Transformed Monad combining the effects of `Self` with the original Monad.
    static func _lift<MTag: MonadTag>(_ m: KindApplication<MTag, K1Arg>) -> KindApplication<K2Tag, K2TagArgs>
}

extension MonadTrans {
    /// Lifts a Monad into a transformed Monad that adds the effects of `Self`.
    ///
    /// - Parameter m: Monad to lift
    /// - Returns: Transformed Monad combining the effects of `Self` with the original Monad.
    public static func lift<M: Monad>(_ m: M) -> Self where K2Tag.MTag == M.K1Tag, M.K1Arg == K1Arg {
        return (unkind2 • _lift) <| m.kind
    }
}
