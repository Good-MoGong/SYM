//
//  SPM+Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 박서연 on 2024/02/09.
//

import ProjectDescription

public extension TargetDependency {
    static let kingfisher: TargetDependency = .package(product: "Kingfisher")
    static let firebaseAuth: TargetDependency = .package(product: "FirebaseAuth")
    static let firestore: TargetDependency = .package(product: "FirebaseFirestore")
    
    // FCM 추가
    static let firebaseAnalytics: TargetDependency = .package(product: "FirebaseAnalytics")
    static let firebaseMessaging: TargetDependency = .package(product: "FirebaseMessaging")
}

public extension Package {
    
    static let kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher.git",
                                             requirement: .upToNextMajor(from: "5.15.6"))
    static let firebase: Package = .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
                                           requirement: .upToNextMajor(from: "10.4.0"))
}
