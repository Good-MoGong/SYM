//
//  Script.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//


import ProjectDescription

public extension TargetScript {
    /// 린트 적용
    static let swiftLintPath = Self.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint", basedOnDependencyAnalysis: false)
    
}
