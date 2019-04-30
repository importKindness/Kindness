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

/// `K1Tag` tag for `Either`
public struct EitherK1Tag<L> {
    private let value: Any

    fileprivate init<R>(_ value: Either<L, R>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<R>() -> Either<L, R> {
        return value as! Either<L, R> //swiftlint:disable:this force_cast
    }
}

extension EitherK1Tag: AltTag {
    public static func _alt<A>(
        _ lhs: KindApplication<EitherK1Tag<L>, A>) -> (KindApplication<EitherK1Tag<L>, A>
    ) -> KindApplication<EitherK1Tag<L>, A> {
        return Either<L, A>._alt(lhs)
    }
}

extension EitherK1Tag: ApplicativeTag {
    public static func _pure<A>(_ a: A) -> KindApplication<EitherK1Tag<L>, A> {
        return Either<L, A>._pure(a)
    }
}

extension EitherK1Tag: ApplyTag {
    public static func _apply<A, B>(
        _ fab: KindApplication<EitherK1Tag<L>, (A) -> B>, _ value: KindApplication<EitherK1Tag<L>, A>
    ) -> KindApplication<EitherK1Tag<L>, B> {
        return Either<L, A>._apply(fab, value)
    }
}

extension EitherK1Tag: BindTag {
    public static func _bind<A, B>(
        _ m: KindApplication<EitherK1Tag<L>, A>, _ f: @escaping (A) -> KindApplication<EitherK1Tag<L>, B>
    ) -> KindApplication<EitherK1Tag<L>, B> {
        return Either<L, A>.unkind(m)._bind(f)
    }
}

extension EitherK1Tag: ExtendTag {
    public static func _extend<A, B>(
        _ f: @escaping (KindApplication<EitherK1Tag<L>, A>) -> B, _ w: KindApplication<EitherK1Tag<L>, A>
    ) -> KindApplication<EitherK1Tag<L>, B> {
        return Either<L, A>.unkind(w)._extend(f)
    }
}

extension EitherK1Tag: FunctorTag {
    public static func _fmap<A, B>(
        _ f: @escaping (A) -> B, _ value: KindApplication<EitherK1Tag<L>, A>
    ) -> KindApplication<EitherK1Tag<L>, B> {
        return Either<L, A>._fmap(f, value)
    }
}

extension EitherK1Tag: MonadTag { }

/// `K2Tag` for `Either`
public struct EitherK2Tag {
    private let value: Any

    fileprivate init<L, R>(_ value: Either<L, R>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<L, R>() -> Either<L, R> {
        return value as! Either<L, R> //swiftlint:disable:this force_cast
    }
}

/// Represents a choice where the two outcomes can have different types.
///
/// - left: One possible choice. Often used to represent an error case.
/// - right: One possible choice. Often used to represent a success case.
public enum Either<L, R> {
    case left(L)
    case right(R)
}

extension Either: Equatable where L: Equatable, R: Equatable {
    public static func == (lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
        switch (lhs, rhs) {
        case let (.left(l), .left(r)):
            return l == r

        case let (.right(l), .right(r)):
            return l == r

        default:
            return false
        }
    }
}

extension Either: Hashable where L: Hashable, R: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .left(let l):
            return hasher.combine(l.hashValue)

        case .right(let r):
            return hasher.combine(r.hashValue)
        }
    }
}

extension Either: K1 {
    public typealias K1Tag = EitherK1Tag<L>
    public typealias K1Arg = R

    public var kind: K1Self {
        return KindApplication(K1Tag(self))
    }

    public static func unkind(_ kind: K1Self) -> Either<L, R> {
        return kind.tag.unsafeUnwrap()
    }
}

extension Either: K2 {
    public typealias K2Tag = EitherK2Tag
    public typealias K2Arg = L

    public var kind2: K2Self {
        return KindApplication(K2Tag(self))
    }

    public static func unkind2(_ kind: K2Self) -> Either<L, R> {
        return kind.tag.unsafeUnwrap()
    }
}

extension Either: Alt {
    public static func _alt(
        _ lhs: KindApplication<K1Tag, K1Arg>
    ) -> (KindApplication<K1Tag, K1Arg>) -> KindApplication<K1Tag, K1Arg> {
        return { rhs in
            switch (unkind(lhs), unkind(rhs)) {
            case (.left, _):
                return rhs

            default:
                return lhs
            }
        }
    }
}

extension Either: Applicative {
    public static func _pure(_ a: K1Arg) -> KindApplication<K1Tag, K1Arg> {
        return Either<L, R>.right(a).kind
    }
}

extension Either: Apply {
    public static func _apply<A, B>(
        _ fab: KindApplication<K1Tag, (A) -> B>, _ value: KindApplication<K1Tag, A>
    ) -> KindApplication<K1Tag, B> {
        switch Either<L, (A) -> B>.unkind(fab) {
        case .left(let l):
            return Either<L, B>.left(l).kind

        case .right(let f):
            return f <^> value
        }
    }
}

extension Either: Bind {
    public func _bind<B>(_ f: @escaping (K1Arg) -> KindApplication<K1Tag, B>) -> KindApplication<K1Tag, B> {
        switch self {
        case .left(let l):
            return Either<L, B>.left(l).kind

        case .right(let r):
            return f(r)
        }
    }
}

extension Either: Extend {
    public func _extend<B>(_ f: @escaping (KindApplication<K1Tag, K1Arg>) -> B) -> KindApplication<K1Tag, B> {
        switch self {
        case .left(let l):
            return Either<L, B>.left(l).kind

        case .right:
            return Either<L, B>.right(f(self.kind)).kind
        }
    }
}

extension Either: Functor {
    public static func _fmap<T>(_ f: @escaping (K1Arg) -> T, _ value: K1Self) -> K1Other<T> {
        switch unkind(value) {
        case .left(let l):
            return Either<L, T>.left(l).kind

        case .right(let r):
            return Either<L, T>.right(f(r)).kind
        }
    }
}

extension Either: Monad { }
