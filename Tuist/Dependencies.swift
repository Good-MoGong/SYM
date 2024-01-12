//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

// 사용할 라이브러리 정의 -> 예시 firebase auth
import ProjectDescription

let dependencies = Dependencies(
    /// 테스트용 파베 추가
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.4.0"))
        ]
    ),
    platforms: [.iOS]
)
