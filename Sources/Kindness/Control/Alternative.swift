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

public protocol AlternativeTag: ApplicativeTag, PlusTag { }

/// Combines `Applicative` and `Plus`, supporting an empty element, applying wrapped functions to wrapped values, and
/// lifting values into `Self`.
///
/// Laws:
///
///     Distributivity: (f <|> g) <*> x == (f <*> x) <|> (g <*> x)
///     Annihilation: empty <*> f = empty
public protocol Alternative: Applicative, Plus where K1Tag: AlternativeTag { }
