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

/// Provides implementations for `Foldable` required methods `foldl` and `foldMap` based on the implementation of
/// `foldr`.
public protocol FoldableByFoldR: K1 {
    static func _foldr<B>(_ f: @escaping (K1Arg, B) -> B) -> (B) -> (Self) -> B
}

public extension FoldableByFoldR {
    static func _foldMap<M: Monoid>(_ f: @escaping (K1Arg) -> M) -> (Self) -> M {
        return _foldr({ x, acc in
            return f(x) <> acc
        })(.mempty)
    }

    static func _foldl<B>(_ f: @escaping (B, K1Arg) -> B) -> (B) -> (Self) -> B {
        return { b in
            return { fa in
                return (_foldMap(Dual.init • Endo.init • (flip • curry <| f)) <| fa).unDual.appEndo <| b
            }
        }
    }
}

/// Provides implementations for `Foldable` required methods `foldr` and `foldMap` based on the implementation of
/// `foldl`.
public protocol FoldableByFoldL: K1 {
    static func _foldl<B>(_ f: @escaping (B, K1Arg) -> B) -> (B) -> (Self) -> B
}

public extension FoldableByFoldL {
    static func _foldMap<M: Monoid>(_ f: @escaping (K1Arg) -> M) -> (Self) -> M {
        return _foldl({ acc, x in
            return acc <> f(x)
        })(.mempty)
    }

    static func _foldr<B>(_ f: @escaping (K1Arg, B) -> B) -> (B) -> (Self) -> B {
        return { b in
            return { fa in
                return (_foldMap(Endo.init • curry(f)) <| fa).appEndo <| b
            }
        }
    }
}

/// Provides implementations for `Foldable` required methods `foldr` and `foldl` based on the implementation of
/// `foleMap`
public protocol FoldableByFoldMap: K1 {
    static func _foldMap<M: Monoid>(_ f: @escaping (K1Arg) -> M) -> (Self) -> M
}

public extension FoldableByFoldMap {
    static func _foldr<B>(_ f: @escaping (K1Arg, B) -> B) -> (B) -> (Self) -> B {
        return { b in
            return { fa in
                return (_foldMap(Endo.init • curry(f)) <| fa).appEndo <| b
            }
        }
    }

    static func _foldl<B>(_ f: @escaping (B, K1Arg) -> B) -> (B) -> (Self) -> B {
        return { b in
            return { fa in
                return (_foldMap(Dual.init • Endo.init • (flip • curry <| f)) <| fa).unDual.appEndo <| b
            }
        }
    }
}

/// Types that can be folded
public protocol Foldable: K1 {
    static func _foldr<B>(_ f: @escaping (K1Arg, B) -> B) -> (B) -> (Self) -> B
    static func _foldl<B>(_ f: @escaping (B, K1Arg) -> B) -> (B) -> (Self) -> B
    static func _foldMap<M: Monoid>(_ f: @escaping (K1Arg) -> M) -> (Self) -> M
}

/// Fold from right to left
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure and accumulation value, folds the initial structure from right
/// to left.
public func foldr<F: Foldable, B>(_ f: @escaping (F.K1Arg, B) -> B) -> (B) -> (F) -> B {
    return F._foldr(f)
}

/// Fold from right to left
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure and accumulation value, folds the initial structure from right
/// to left.
public func foldr<F: Foldable, B>(_ f: @escaping (F.K1Arg) -> (B) -> B) -> (B) -> (F) -> B {
    return foldr(uncurry(f))
}

/// Fold from right to left
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure and accumulation value, folds the initial structure from right
/// to left.
public func foldr<F: Foldable, B>(_ f: @escaping (F.K1Arg, B) -> B, _ b: B) -> (F) -> B {
    return F._foldr(f) <| b
}

/// Fold from left to right
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure and accumulation value, folds the initial structure from left
/// to right.
public func foldl<F: Foldable, B>(_ f: @escaping (B, F.K1Arg) -> B) -> (B) -> (F) -> B {
    return F._foldl(f)
}

/// Fold from left to right
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure and accumulation value, folds the initial structure from left
/// to right.
public func foldl<F: Foldable, B>(_ f: @escaping (B) -> (F.K1Arg) -> B) -> (B) -> (F) -> B {
    return foldl(uncurry(f))
}

/// Fold from left to right
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure and accumulation value, folds the initial structure from left
/// to right.
public func foldl<F: Foldable, B>(_ f: @escaping (B, F.K1Arg) -> B, _ b: B) -> (F) -> B {
    return F._foldl(f) <| b
}

/// Fold from right to left by mapping each value into a monoid and appending
///
/// - Parameter f: Function to perform each step of the fold
/// - Returns: Function that given an initial structure folds the initial structure from right to left by mapping each
/// value into a monoid and prepending. The starting accumulator value is the empty value for the monoid.
public func foldMap<F: Foldable, M: Monoid>(_ f: @escaping (F.K1Arg) -> M) -> (F) -> M {
    return F._foldMap(f)
}

/// Given a `Foldable` structure containing a monoid, fold by prepending all contained values from right to left.
public func fold<F: Foldable, M: Monoid>(_ f: F) -> M where F.K1Arg == M {
    return foldMap(id) <| f
}
