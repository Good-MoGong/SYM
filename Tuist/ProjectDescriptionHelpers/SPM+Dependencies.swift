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
    static let firestoreSwift: TargetDependency = .package(product: "FirebaseFirestoreSwift")
    static let firebaseDatabase: TargetDependency = .package(product: "FirebaseDatabase")
    static let firebaseDatabaseSwift: TargetDependency = .package(product: "FirebaseDatabaseSwift")
    static let firebaseFunctions: TargetDependency = .package(product: "FirebaseFunctions")
    static let firebaseCrashlytics: TargetDependency = .package(product: "FirebaseCrashlytics")
    
}

public extension Package {
    
    static let kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher.git",
                                             requirement: .upToNextMajor(from: "5.15.6"))
    static let firebase: Package = .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
                                           requirement: .upToNextMajor(from: "10.4.0"))
}
