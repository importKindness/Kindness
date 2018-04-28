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

precedencegroup CompositionPrecedenceRight {
    higherThan: CompositionPrecedenceLeft
    associativity: right
}

precedencegroup CompositionPrecedenceLeft {
    higherThan: BitwiseShiftPrecedence
    associativity: left
}

precedencegroup FunctorPrecedence {
    lowerThan: ComparisonPrecedence
    higherThan: LogicalConjunctionPrecedence
    associativity: left
}

precedencegroup MonadPrecedence {
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AltPrecedence
    associativity: left
}

precedencegroup AltPrecedence {
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: ApplyPrecedence
    associativity: left
}

precedencegroup ApplyPrecedence {
    lowerThan: LogicalDisjunctionPrecedence
    associativity: right
}
