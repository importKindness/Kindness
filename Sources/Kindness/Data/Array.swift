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

extension ArrayTag: ApplyTag {
    public static func _apply<A, B>(
        _ fab: KindApplication<ArrayTag, (A) -> B>
        ) -> (KindApplication<ArrayTag, A>) -> KindApplication<ArrayTag, B> {
        return [(A) -> B]._apply(fab)
    }
}

extension ArrayTag: FunctorTag {
    public static func _fmap<A, B>(
        _ f: @escaping (A) -> B
    ) -> (KindApplication<ArrayTag, A>) -> KindApplication<ArrayTag, B> {
        return [A]._fmap(f)
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

extension Array: Apply {
    public static func _apply<A, B>(
        _ fab: KindApplication<K1Tag, (A) -> B>
    ) -> (KindApplication<K1Tag, A>) -> KindApplication<K1Tag, B> {
        let fs = [(A) -> B].unkind(fab)
        return { kxs in
            return [A].unkind(kxs).flatMap({ x in
                return fs.map({ $0 <| x })
            }).kind
        }
    }
}

extension Array: Foldable, FoldableByFoldL {
    public static func _foldl<B>(_ f: @escaping (B, Element) -> B) -> (B) -> (Array<Element>) -> B {
        return { b in
            return { xs in
                return xs.reduce(b, f)
            }
        }
    }
}

extension Array: Functor {
    public static func _fmap<T>(_ f: @escaping (Element) -> T) -> (K1Self) -> K1Other<T> {
        return [T].kind • { $0.map(f) } • [Element].unkind
    }
}

extension Array: Monoid {
    public static var mempty: [Element] {
        return []
    }
}

extension Array: Semigroup {
    public static func <> (lhs: [Element], rhs: [Element]) -> [Element] {
        return lhs + rhs
    }
}
