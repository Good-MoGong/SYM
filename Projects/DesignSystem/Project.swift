//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2024/03/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

let designTarget = Target.makeTarget(name: "DesignSystem",
                                  platform: .iOS,
                                  product: .framework,
                                  deploymentTarget: .iOS(targetVersion: "16.4",
                                                         devices: [.iphone],
                                                         supportsMacDesignedForIOS: true),
                                  dependencies: [],
                                  scripts: [],
                                  infoPlistPath: "Support/Info.plist",
                                  coreDataModels: [],
                                  isResource: true)

// 위의 타겟으로 프로젝트 생성, 여기서만 시크릿 키 사용하니까 true 로 설정
let DesignProject = Project.makeProject(targets: designTarget, name: "DesignSystem", packages: [])
