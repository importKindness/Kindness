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

precedencegroup InfixR9 {
    higherThan: InfixL8, InfixR8, BitwiseShiftPrecedence
    associativity: right
}

precedencegroup InfixL9 {
    higherThan: InfixL8, InfixR8, BitwiseShiftPrecedence
    associativity: left
}

precedencegroup InfixR8 {
    lowerThan: BitwiseShiftPrecedence
    higherThan: MultiplicationPrecedence, InfixR7
    associativity: right
}

precedencegroup InfixL8 {
    lowerThan: BitwiseShiftPrecedence
    higherThan: MultiplicationPrecedence, InfixR7
    associativity: left
}

precedencegroup InfixR7 {
    lowerThan: BitwiseShiftPrecedence
    higherThan: AdditionPrecedence, InfixR6
    associativity: right
}

//precedencegroup InfixL7 { // Use MultiplicationPrecedence
//    lowerThan: BitwiseShiftPrecedence
//    higherThan: AdditionPrecedence, InfixR6
//    associativity: left
//}

precedencegroup InfixR6 {
    lowerThan: MultiplicationPrecedence
    higherThan: InfixL5, InfixR5, RangeFormationPrecedence
    associativity: right
}

//precedencegroup InfixL6 { // Use AdditionPrecedence
//    lowerThan: MultiplicationPrecedence
//    higherThan: InfixL5, InfixR5, RangeFormationPrecedence
//    associativity: left
//}

precedencegroup InfixR5 {
    lowerThan: NilCoalescingPrecedence
    higherThan: InfixL4, InfixR4, ComparisonPrecedence
    associativity: right
}

precedencegroup InfixL5 {
    lowerThan: NilCoalescingPrecedence
    higherThan: InfixL4, InfixR4, ComparisonPrecedence
    associativity: left
}

precedencegroup InfixR4 {
    lowerThan: NilCoalescingPrecedence
    higherThan: LogicalConjunctionPrecedence, InfixR3, ComparisonPrecedence
    associativity: right
}

precedencegroup InfixL4 {
    lowerThan: NilCoalescingPrecedence
    higherThan: LogicalConjunctionPrecedence, InfixR3, ComparisonPrecedence
    associativity: left
}

precedencegroup InfixR3 {
    lowerThan: ComparisonPrecedence
    higherThan: LogicalDisjunctionPrecedence, InfixR2
    associativity: right
}

//precedencegroup InfixL3 { // Use LogicalConjunctionPrecedence
//    lowerThan: ComparisonPrecedence
//    higherThan: LogicalDisjunctionPrecedence, InfixR2
//    associativity: left
//}

precedencegroup InfixR2 {
    lowerThan: LogicalConjunctionPrecedence
    higherThan: InfixR1
    associativity: right
}

//precedencegroup InfixL2 { Use LogicalDisjunctionPrecedence
//    lowerThan: LogicalConjunctionPrecedence
//    higherThan: InfixL1, InfixR1, LogicalDisjunctionPrecedence
//    associativity: left
//}

precedencegroup InfixR1 {
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: InfixL0, InfixR0
    associativity: right
}

precedencegroup InfixL1 {
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: InfixL0, InfixR0
    associativity: left
}

precedencegroup InfixR0 {
    lowerThan: LogicalDisjunctionPrecedence
    associativity: right
}

precedencegroup InfixL0 {
    lowerThan: LogicalDisjunctionPrecedence
    associativity: left
}
