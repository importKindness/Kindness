#! /usr/bin/env xcrun --sdk macosx swift

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

let arguments = CommandLine.arguments

guard arguments.count == 3 else {
        print("error: Usage: ensureNoProjectBuildSettings.swift <path_to_pbxproj> <target>")
        exit(EX_USAGE)
}

let projectPath = arguments[1]
let targetName = arguments[2]

guard let projectDict = NSDictionary(contentsOfFile: projectPath),
    let objectsDict = projectDict["objects"] as? NSDictionary else {
        print("error: Unable to load project file \(projectPath)")
        exit(EX_DATAERR)
}

struct Target {
    let id: String
    let name: String
    let buildConfigurationListId: String
}

guard let buildConfigurationListId = objectsDict.compactMap({ _, object -> String? in
    guard
        let objectDict = object as? NSDictionary,
        let isa = objectDict["isa"] as? String,
        isa == "PBXNativeTarget",
        let name = objectDict["name"] as? String,
        name == targetName else {
            return nil
    }

    return objectDict["buildConfigurationList"] as? String
}).first else {
    print("error: Unable to find target \(targetName) in project file \(projectPath)")
    exit(EX_DATAERR)
}

guard
    let buildConfigurationListDict = objectsDict[buildConfigurationListId] as? NSDictionary,
    let buildConfigurationIds = buildConfigurationListDict["buildConfigurations"] as? [String] else {
        print("error: Unable to find build configurations for target \(targetName) in project file \(projectPath)")
        exit(EX_DATAERR)
}

let warnings = buildConfigurationIds.flatMap({ id -> [String] in
    guard let configurationDict = objectsDict[id] as? NSDictionary,
        let configurationName = configurationDict["name"] as? String else {
        print("error: Unable to load configuration \(id) for target \(targetName) in project file \(projectPath)")
        exit(EX_DATAERR)
    }

    guard let buildSettings = configurationDict["buildSettings"] as? [String: String] else {
        return []
    }

    return buildSettings.map({ key, value in
        return "warning: Build setting \"\(key) = \(value)\" for \(configurationName) target \(targetName) is set explicitly in project file. It should be moved to an appropriate XCConfig instead."
    })
})

print(warnings.joined(separator: "\n"))
