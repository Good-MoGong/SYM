//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

// App -> 우리 메인 SYM (framework에서 app으로 선택되는 것)
// 나머지는 그냥 framework

// app, 즉 메인 타겟 설정(SYM)
// firebase 타켓을 가진 프로젝트에 의존성을 가진 메인 타겟 생성
let appTarget = Target.makeTarget(name: "SYM",
                                  platform: .iOS,
                                  product: .app,
                                  deploymentTarget: .iOS(targetVersion: "16.4",
                                                         devices: [.iphone],
                                                         supportsMacDesignedForIOS: true),
                                  dependencies: [.project(target: "FirebaseSPM", 
                                                          path: .relativeToRoot("\(projectFolder)/FirebaseSPM")),
                                                 .project(target: "KakaoSPM",
                                                          path: .relativeToRoot("\(projectFolder)/KakaoSPM")),
                                                 .project(target: "DesignSystem",
                                                          path: .relativeToRoot("\(projectFolder)/DesignSystem"))],
                                  scripts: [], // [.swiftLintPath],
                                  infoPlistPath: "Support/Info.plist",
                                  coreDataModels: [],
                                  // 메인만 리소스 있음
                                  isResource: true)

// 위의 타겟으로 프로젝트 생성, 여기서만 시크릿 키 사용하니까 true 로 설정
let appProject = Project.makeProject(targets: appTarget, name: "SYM", isXcconfigSet: true, packages: [])
