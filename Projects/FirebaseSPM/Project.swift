//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

let firebaseTarget = Target.makeTarget(name: "FirebaseSPM",
                                       platform: .iOS,
                                       product: .staticFramework,
                                       deploymentTarget: .iOS(targetVersion: "16.4",
                                                              devices: [.iphone],
                                                              supportsMacDesignedForIOS: true),
                                       dependencies: [.SPM.fireAuth,
                                                      .SPM.firestore,
                                                      .SPM.firestoreSwift,
                                                      .SPM.firebaseAnalytics,
                                                      .SPM.firebaseMessaging],
                                       scripts: [],
                                       infoPlistPath: "",
                                       coreDataModels: [],
                                       isResource: false) // 나머지 리소스 없음

// 위의 타겟으로 프로젝트 생성
let firebaseProject = Project.makeProject(targets: firebaseTarget, name: "FirebaseSPM", packages: [])



