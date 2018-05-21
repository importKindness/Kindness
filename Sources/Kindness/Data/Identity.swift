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

/// HKT tag for `Identity`
public struct IdentityK1Tag {
    let value: Any

    init<A>(_ value: Identity<A>) {
        self.value = value
    }

    public func unsafeUnwrap<A>() -> Identity<A> {
        return value as! Identity<A> //swiftlint:disable:this force_cast
    }
}

extension IdentityK1Tag: AltTag {
    public static func _alt<A>(
        _ lhs: KindApplication<IdentityK1Tag, A>
    ) -> (KindApplication<IdentityK1Tag, A>) -> KindApplication<IdentityK1Tag, A> {
        return Identity<A>._alt(lhs)
    }
}

extension IdentityK1Tag: ApplicativeTag {
    public static func _pure<A>(_ a: A) -> KindApplication<IdentityK1Tag, A> {
        return Identity<A>._pure(a)
    }
}

extension IdentityK1Tag: ApplyTag {
    public static func _apply<A, B>(
        _ fab: KindApplication<IdentityK1Tag, (A) -> B>, _ value: KindApplication<IdentityK1Tag, A>
    ) -> KindApplication<IdentityK1Tag, B> {
        return Identity<A>._apply(fab, value)
    }
}

extension IdentityK1Tag: BindTag {
    public static func _bind<A, B>(
        _ m: KindApplication<IdentityK1Tag, A>, _ f: @escaping (A) -> KindApplication<IdentityK1Tag, B>
    ) -> KindApplication<IdentityK1Tag, B> {
        return Identity<A>.unkind(m)._bind(f)
    }
}

extension IdentityK1Tag: ExtendTag {
    public static func _extend<A, B>(
        _ f: @escaping (KindApplication<IdentityK1Tag, A>) -> B, _ w: KindApplication<IdentityK1Tag, A>
    ) -> KindApplication<IdentityK1Tag, B> {
        return Identity<A>.unkind(w)._extend(f)
    }
}

extension IdentityK1Tag: FunctorTag {
    public static func _fmap<A, B>(
        _ f: @escaping (A) -> B, _ value: KindApplication<IdentityK1Tag, A>
    ) -> KindApplication<IdentityK1Tag, B> {
        return Identity<A>._fmap(f, value)
    }
}

extension IdentityK1Tag: MonadTag { }

/// Simple container for a value
public struct Identity<A> {

    /// Contained value
    public let value: A

    public init(_ value: A) {
        self.value = value
    }
}

extension Identity: Equatable where A: Equatable {
    public static func == (_ lhs: Identity<A>, _ rhs: Identity<A>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Identity: Hashable where A: Hashable {
    public var hashValue: Int {
        return value.hashValue
    }
}

extension Identity: K1 {
    public typealias K1Tag = IdentityK1Tag
    public typealias K1Arg = A

    public var kind: KindApplication<K1Tag, K1Arg> {
        return KindApplication(K1Tag(self))
    }

    public static func unkind(_ kind: K1Self) -> Identity<A> {
        return kind.tag.unsafeUnwrap()
    }
}

extension Identity: Alt {
    public static func _alt(
        _ lhs: KindApplication<IdentityK1Tag, A>
    ) -> (KindApplication<IdentityK1Tag, A>) -> KindApplication<IdentityK1Tag, A> {
        return { _ in lhs }
    }
}

extension Identity: Applicative {
    public static func _pure(_ a: A) -> KindApplication<IdentityK1Tag, A> {
        return Identity(a).kind
    }
}

extension Identity: Apply {
    public static func _apply<A, B>(
        _ fab: KindApplication<IdentityK1Tag, (A) -> B>, _ value: KindApplication<IdentityK1Tag, A>
    ) -> KindApplication<IdentityK1Tag, B> {
        return Identity<B>(Identity<(A) -> B>.unkind(fab).value <| Identity<A>.unkind(value).value).kind
    }
}

extension Identity: Bind {
    public func _bind<B>(_ f: @escaping (A) -> KindApplication<IdentityK1Tag, B>) -> KindApplication<IdentityK1Tag, B> {
        return f(self.value)
    }
}

extension Identity: Extend {
    public func _extend<B>(
        _ f: @escaping (KindApplication<IdentityK1Tag, A>) -> B
    ) -> KindApplication<IdentityK1Tag, B> {
        return Identity<B>(f(self.kind)).kind
    }
}

extension Identity: Functor {
    public static func _fmap<T>(
        _ f: @escaping (A) -> T, _ value: KindApplication<IdentityK1Tag, A>
    ) -> KindApplication<IdentityK1Tag, T> {
        return Identity<T>(f(Identity.unkind(value).value)).kind
    }
}

extension Identity: Monad { }
