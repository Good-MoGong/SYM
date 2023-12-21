//
//  SPM+TargetDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

import ProjectDescription

// 타겟 생성 시 의존성을 편리하게 주입하기 위해서 extenstion으로 빼서 정의해서 . 으로 사용하게 생성
public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let firestore = TargetDependency.external(name: "FirebaseFirestore")
    static let fireAuth = TargetDependency.external(name: "FirebaseAuth")
    static let firestoreSwift = TargetDependency.external(name: "FirebaseFirestoreSwift")
}
