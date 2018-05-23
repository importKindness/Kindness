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

public struct ReaderTImplK1Tag<Environment, MTag: MonadTag> {
    private let value: Any

    fileprivate init<A>(_ value: ReaderTImpl<Environment, MTag, A>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<A>() -> ReaderTImpl<Environment, MTag, A> {
        return self.value as! ReaderTImpl<Environment, MTag, A> //swiftlint:disable:this force_cast
    }
}

public struct ReaderTImplK2Tag<Environment> {
    private let value: Any

    fileprivate init<MTag: MonadTag, A>(_ value: ReaderTImpl<Environment, MTag, A>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<MTag: MonadTag, A>() -> ReaderTImpl<Environment, MTag, A> {
        return self.value as! ReaderTImpl<Environment, MTag, A> //swiftlint:disable:this force_cast
    }
}

public struct ReaderTImplK3Tag {
    private let value: Any

    fileprivate init<Environment, MTag: MonadTag, A>(_ value: ReaderTImpl<Environment, MTag, A>) {
        self.value = value
    }

    fileprivate func unsafeUnwrap<Environment, MTag: MonadTag, A>() -> ReaderTImpl<Environment, MTag, A> {
        return self.value as! ReaderTImpl<Environment, MTag, A> //swiftlint:disable:this force_cast
    }
}

public struct ReaderTImpl<Environment, MTag: MonadTag, A> {
    private let runReaderTImpl: (Environment) -> KindApplication<MTag, A>

    public init(_ runReaderT: @escaping (Environment) -> KindApplication<MTag, A>) {
        self.runReaderTImpl = runReaderT
    }

    public init<M: Monad>(_ runReaderT: @escaping (Environment) -> M) where M.K1Tag == MTag, M.K1Arg == A {
        self.runReaderTImpl = M.kind • runReaderT
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
