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

public struct ArrayTag {
    private let value: Any

    fileprivate init<T>(_ value: [T]) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<T>() -> [T] {
        return value as! [T] //swiftlint:disable:this force_cast
    }
}

extension ArrayTag: AltTag {
    public static func _alt<A>(
        _ lhs: KindApplication<ArrayTag, A>
    ) -> (KindApplication<ArrayTag, A>) -> KindApplication<ArrayTag, A> {
        return [A]._alt(lhs)
    }
}

extension ArrayTag: AlternativeTag { }

extension ArrayTag: ApplicativeTag {
    public static func _pure<A>(_ a: A) -> KindApplication<ArrayTag, A> {
        return [A]._pure(a)
    }
}

extension ArrayTag: ApplyTag {
    public static func _apply<A, B>(
        _ fab: KindApplication<ArrayTag, (A) -> B>,
        _ value: KindApplication<ArrayTag, A>
    ) -> KindApplication<ArrayTag, B> {
        return [(A) -> B]._apply(fab, value)
    }
}

extension ArrayTag: BindTag {
    public static func _bind<A, B>(
        _ m: KindApplication<ArrayTag, A>, _ f: @escaping (A) -> KindApplication<ArrayTag, B>
    ) -> KindApplication<ArrayTag, B> {
        return [A].unkind(m)._bind(f)
    }
}

extension ArrayTag: FoldableTag {
    public static func _foldr<A, B>(_ f: @escaping (A, B) -> B) -> (B) -> (KindApplication<ArrayTag, A>) -> B {
        return [A]._foldr(f)
    }

    public static func _foldl<A, B>(_ f: @escaping (B, A) -> B) -> (B) -> (KindApplication<ArrayTag, A>) -> B {
        return [A]._foldl(f)
    }

    public static func _foldMap<A, M: Monoid>(_ f: @escaping (A) -> M) -> (KindApplication<ArrayTag, A>) -> M {
        return [A]._foldMap(f)
    }
}

extension ArrayTag: FunctorTag {
    public static func _fmap<A, B>(
        _ f: @escaping (A) -> B,
        _ value: KindApplication<ArrayTag, A>
    ) -> KindApplication<ArrayTag, B> {
        return [A]._fmap(f, value)
    }
}

extension ArrayTag: MonadTag { }

extension ArrayTag: MonadPlusTag { }

extension ArrayTag: MonadZeroTag { }

extension ArrayTag: PlusTag {
    public static func empty<A>() -> KindApplication<ArrayTag, A> {
        return [A].empty.kind
    }
}

extension Array: K1 {
    public typealias K1Tag = ArrayTag
    public typealias K1Arg = Element

    public var kind: KindApplication<K1Tag, K1Arg> {
        return KindApplication(K1Tag(self))
    }

    public static func unkind(_ kind: K1Self) -> [Element] {
        return kind.tag.unsafeUnwrap()
    }
}

extension Array: Alt {
    public static func _alt(
        _ lhs: KindApplication<K1Tag, K1Arg>
    ) -> (KindApplication<K1Tag, K1Arg>) -> KindApplication<K1Tag, K1Arg> {
        return { rhs in ([K1Arg].unkind(lhs) <> [K1Arg].unkind(rhs)).kind }
    }
}

extension Array: Alternative { }

extension Array: Applicative {
    public static func _pure(_ a: K1Arg) -> KindApplication<K1Tag, K1Arg> {
        return [a].kind
    }
}

extension Array: Apply {
    public static func _apply<A, B>(
        _ fab: KindApplication<K1Tag, (A) -> B>,
        _ value: KindApplication<K1Tag, A>
    ) -> KindApplication<K1Tag, B> {
        let fs = [(A) -> B].unkind(fab)
        return fs.flatMap({ f -> [B] in
            return [A].unkind(value).flatMap({ x -> B in
                return f(x)
            })
        }).kind
    }
}

extension Array: Bind {
    public func _bind<B>(_ f: @escaping (K1Arg) -> KindApplication<K1Tag, B>) -> KindApplication<K1Tag, B> {
        return flatMap([B].unkind • f).kind
    }
}

extension Array: Foldable, FoldableByFoldL {
    public static func _foldl<B>(_ f: @escaping (B, Element) -> B) -> (B) -> (KindApplication<K1Tag, K1Arg>) -> B {
        return { b in
            return { xs in
                return [Element].unkind(xs).reduce(b, f)
            }
        }
    }
}

extension Array: Functor {
    public static func _fmap<T>(_ f: @escaping (Element) -> T, _ value: K1Self) -> K1Other<T> {
        return ([T].kind • { $0.map(f) } • [Element].unkind) <| value
    }
}

extension Array: Monad { }

extension Array: MonadPlus { }

extension Array: MonadZero { }

extension Array: Monoid {
    public static var mempty: [Element] {
        return []
    }
}

extension Array: Plus {
    public static var empty: [Element] {
        return []
    }
}

extension Array: Semigroup {
    public static func <> (lhs: [Element], rhs: [Element]) -> [Element] {
        return lhs + rhs
    }
}
