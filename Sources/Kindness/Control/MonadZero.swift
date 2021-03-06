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

/// HKT tag for types conforming to `MonadZero`
public protocol MonadZeroTag: AlternativeTag, MonadTag { }

/// Combines `Alternative` and `Monad`, supporting an empty element, applying wrapped functions to wrapped values,
/// lifting values into `Self`, and sequencing dependent operations.
///
/// Laws:
///
///     Annihilation: empty >>- f = empty
public protocol MonadZero: Alternative, Monad { }
