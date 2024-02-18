//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

// firebase spm 용 타겟 생성
let firebaseTarget = Target.makeTarget(name: "FirebaseSPM",
                                       platform: .iOS,
                                       product: .staticFramework,
                                       deploymentTarget: .iOS(targetVersion: "16.0",
                                                              devices: [.iphone, .ipad],
                                                              supportsMacDesignedForIOS: true),
                                       dependencies: [.firebaseAuth,
                                                      .firestore,
                                                      .firebaseAnalytics,
                                                      .firebaseMessaging],
                                       scripts: [],
                                       infoPlistPath: "",
                                       coreDataModels: [],
                                       isResource: false) // 나머지 리소스 없음

// 위의 타겟으로 프로젝트 생성
let firebaseProject = Project.makeProject(targets: firebaseTarget, name: "FirebaseSPM", packages: [.firebase])

