//
//  Define.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

import ProjectDescription
import Foundation


public let workspaceName: String = "SPM"
public let organizationName: String = "Mogong"
public let projectFolder: String = "Projects"


extension String {
    public var projectPath: ProjectDescription.Path {
        return .relativeToRoot("\(projectFolder)/" + self)
    }
}
