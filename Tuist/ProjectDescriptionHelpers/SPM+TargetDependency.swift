import ProjectDescription

// 타겟 생성 시 의존성을 편리하게 주입하기 위해서 extenstion으로 빼서 정의해서 . 으로 사용하게 생성
public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let firestore = TargetDependency.external(name: "FirebaseFirestore")
    static let fireAuth = TargetDependency.external(name: "FirebaseAuth")
    static let firestoreSwift = TargetDependency.external(name: "FirebaseFirestoreSwift")
    static let firebaseAnalytics: TargetDependency = .external(name: "FirebaseAnalytics")
    static let firebaseMessaging: TargetDependency = .external(name:  "FirebaseMessaging")
    
    // 카카오 추가
    static let kakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser")
    static let kakaoSDKAuth = TargetDependency.external(name: "KakaoSDKAuth")
    static let kakaoSDKCommon = TargetDependency.external(name: "KakaoSDKCommon")
    static let kakaoSDKTalk = TargetDependency.external(name: "KakaoSDKTalk")
    static let kakaoSDKTemplate = TargetDependency.external(name: "KakaoSDKTemplate")
    static let kakaoSDKShare = TargetDependency.external(name: "KakaoSDKShare")

}
