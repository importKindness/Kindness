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

import Foundation

/// HKT K1 tag for ReaderT
public struct ReaderTImplK1Tag<Environment, MTag: MonadTag> {
    private let value: Any

    fileprivate init<A>(_ value: ReaderTImpl<Environment, MTag, A>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<A>() -> ReaderTImpl<Environment, MTag, A> {
        return self.value as! ReaderTImpl<Environment, MTag, A> //swiftlint:disable:this force_cast
    }
}

extension ReaderTImplK1Tag: FunctorTag {
    public static func _fmap<A, B>(
        _ f: @escaping (A) -> B, _ value: KindApplication<ReaderTImplK1Tag<Environment, MTag>, A>
    ) -> KindApplication<ReaderTImplK1Tag<Environment, MTag>, B> {
        return ReaderTImpl<Environment, MTag, A>._fmap(f, value)
    }
}

/// HKT K2 tag for ReaderT
public struct ReaderTImplK2Tag<Environment> {
    private let value: Any

    fileprivate init<MTag: MonadTag, A>(_ value: ReaderTImpl<Environment, MTag, A>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<MTag: MonadTag, A>() -> ReaderTImpl<Environment, MTag, A> {
        return self.value as! ReaderTImpl<Environment, MTag, A> //swiftlint:disable:this force_cast
    }
}

/// HKT K3 tag for ReaderT
public struct ReaderTImplK3Tag {
    private let value: Any

    fileprivate init<Environment, MTag: MonadTag, A>(_ value: ReaderTImpl<Environment, MTag, A>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<Environment, MTag: MonadTag, A>() -> ReaderTImpl<Environment, MTag, A> {
        return self.value as! ReaderTImpl<Environment, MTag, A> //swiftlint:disable:this force_cast
    }
}

public typealias ReaderT<Environment, M: Monad> = ReaderTImpl<Environment, M.K1Tag, M.K1Arg>
public typealias Reader<Environment, A> = ReaderT<Environment, Identity<A>>

/// Implementation of ReaderT, a monad transformer that adds a shared environment a computation can reference.
public struct ReaderTImpl<Environment, MTag: MonadTag, A> {
    private let runReaderTImpl: (Environment) -> KindApplication<MTag, A>

    public init(_ runReaderT: @escaping (Environment) -> KindApplication<MTag, A>) {
        self.runReaderTImpl = runReaderT
    }

    public init<M: Monad>(_ runReaderT: @escaping (Environment) -> M) where M.K1Tag == MTag, M.K1Arg == A {
        self.runReaderTImpl = M.kind • runReaderT
    }

    /// Run the receiving ReaderT with the provided environment.
    public func run(_ r: Environment) -> KindApplication<MTag, A> {
        return runReaderTImpl(r)
    }

    /// Run the receiving ReaderT with the provided environment.
    public func run<M: Monad>(_ r: Environment) -> M where M.K1Tag == MTag, M.K1Arg == A {
        return M.unkind • runReaderTImpl <| r
    }

    /// Modify the output Monad for the receiving ReaderT
    public func mapReaderT<M2Tag: MonadTag, M2Arg>(
        _ f: @escaping (KindApplication<MTag, A>) -> KindApplication<M2Tag, M2Arg>
    ) -> KindApplication<ReaderTImplK2Tag<Environment>, (M2Tag, M2Arg)> {
        return ReaderTImpl<Environment, M2Tag, M2Arg>(f • runReaderTImpl).kind2
    }

    /// Modify the output Monad for the receiving ReaderT
    public func mapReaderT<M: Monad, N: Monad>(
        _ f: @escaping (M) -> N
    ) -> ReaderT<Environment, N> where M.K1Tag == MTag, M.K1Arg == A {
        return ReaderT<Environment, N>(N.kind • f • M.unkind • self.runReaderTImpl)
    }

    /// Change the environment for the receiving ReaderT
    public func with<Other>(_ f: @escaping (Other) -> Environment) -> ReaderTImpl<Other, MTag, A> {
        return ReaderTImpl<Other, MTag, A>(runReaderTImpl • f)
    }
}

extension ReaderTImpl: K1 {
    public typealias K1Tag = ReaderTImplK1Tag<Environment, MTag>
    public typealias K1Arg = A

    public var kind: K1Self {
        return KindApplication(K1Tag(self))
    }

    public static func unkind(_ kind: K1Self) -> ReaderTImpl<Environment, MTag, A> {
        return kind.tag.unsafeUnwrap()
    }
}

extension ReaderTImpl: K2 {
    public typealias K2Tag = ReaderTImplK2Tag<Environment>
    public typealias K2Arg = MTag

    public var kind2: K2Self {
        return KindApplication(K2Tag(self))
    }

    public static func unkind2(_ kind: K2Self) -> ReaderTImpl<Environment, MTag, A> {
        return kind.tag.unsafeUnwrap()
    }
}

extension ReaderTImpl: K3 {
    public typealias K3Tag = ReaderTImplK3Tag
    public typealias K3Arg = Environment

    public var kind3: K3Self {
        return KindApplication(K3Tag(self))
    }

    public static func unkind3(_ kind: K3Self) -> ReaderTImpl<Environment, MTag, A> {
        return kind.tag.unsafeUnwrap()
    }
}

extension ReaderTImpl: Functor {
    public static func _fmap<T>(
        _ f: @escaping (K1Arg) -> T, _ value: KindApplication<K1Tag, K1Arg>
    ) -> KindApplication<K1Tag, T> {
        return ReaderTImpl<Environment, MTag, T> { environment -> KindApplication<MTag, T> in
            return MTag._fmap(f, unkind(value).run(environment))
        } .kind
    }
}
