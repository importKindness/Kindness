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

/// HKT tag for `Monad`s
public protocol MonadTag: ApplicativeTag, BindTag { }

/// Combines `Applicative` and `Bind`, supporting both lifting of values into `Self` and composing operations
/// sequentially.
public protocol Monad: Applicative, Bind { }

/// Provides an implementation for `Apply` required method `_apply` based on `>>-`
public protocol ApplyByMonad: Monad { }

public extension ApplyByMonad {
    static func _apply<A, B>(
        _ fab: KindApplication<K1Tag, (A) -> B>
    ) -> (KindApplication<K1Tag, A>) -> KindApplication<K1Tag, B> {
        return { fa in
            return fab >>- { ab in
                return fa >>- pure • ab
            }
        }
    }
}

/// Provides an implementation for `Functor` required method `_fmap` based on `>>-`
public protocol FunctorByMonad: Monad { }

public extension FunctorByMonad {
    static func _fmap<T>(_ f: @escaping (K1Arg) -> T) -> (K1Self) -> K1Other<T> {
        return { fa in
            return fa >>- pure • f
        }
    }
}
