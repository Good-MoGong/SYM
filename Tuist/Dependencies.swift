//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2023/12/20.
//

// 사용할 라이브러리 정의 -> 예시 firebase auth
import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.4.0")),
            .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMajor(from: "2.0.0"))
        ]
    ),
    platforms: [.iOS]
)
