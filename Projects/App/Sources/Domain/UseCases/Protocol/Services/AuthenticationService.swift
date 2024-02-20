//
//  AuthenticationService.swift
//  LMessenger
//
//  Created by 박서연 on 2024/01/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseFirestore

// 인증 에러 정의
enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidated
}

// 인증을 담당할 서비스
protocol AuthenticationServiceType {
    // 로그인 세션
    func checkAuthenticationState() -> String?
    
    // MARK: - Apple 로그인
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError>
    
    // MARK: - 카카오 로그인
    /// 카카오 토큰 확인
    func checkKakaoToken() -> AnyPublisher<Bool, ServiceError>
    /// 카카오 로그인 (분기처리)
    func kakaoLogin()
    /// 앱으로 카카오 로그인 진행
    func signInWithKakaoApp()
    /// 웹으로 카카오 로그인 진행
    func signInWithKakaoWeb()
    /// Firebase에 이메일/비밀번호로 가입
    func signupWithFirebase() -> AnyPublisher<Bool, ServiceError>
    
    // MARK: - 로그아웃
    func logout() -> AnyPublisher<Void, ServiceError>
    func logoutWithKakao()
    
    // firebase 에 닉네임이 저장되어 있는지 아닌지 확인하기
    func checkUserNickname(userID: String, completion: @escaping (Bool) -> Void)
}

class AuthenticationService: AuthenticationServiceType {
    // 파베를 사용해서 유저 정보 체크 후 유저 정보 추출하기
    // 파베에 해당하는 유저가 있는지 확인하고, 있다면 id값 리턴
    func checkAuthenticationState() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        // 파베에서 미리 유저정보 확인하기
//        if let checkUser = self.checkAuthenticationState() {
//            return checkUser
//        }
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        return nonce
    }
    
    // 완료된 작업 Futuer 생성
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError> {
        // - 최종적으로 하나의 값을 생성한 후 완료되거나 실패하는 Publisher
        // - 어떤 작업을 수행하고 비동기적으로 결과값을 방출할 수 있음
        Future { [weak self] promise in
            self?.handleSignInWithAppleCompletion(authorization, nonce: none) { result in
                switch result {
                case let .success(user):
                    promise(.success(user)) // 작업 완료 시 작업값 방출해주는 operator == future
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - 카카오톡 관련 진행
    /// 카카오 토큰 확인
    func checkKakaoToken() -> AnyPublisher<Bool, ServiceError> {

        // 카카오 토큰이 존재한다면
        Future { [weak self] promise in
            if AuthApi.hasToken() {
                UserApi.shared.accessTokenInfo { accessTokenInfo, error in
                    if let error = error {
                        print("DEBUG: 카카오톡 토큰 가져오기 에러 \(error.localizedDescription)")
                        self?.kakaoLogin(completion: { result in
                            switch result {
                            case let .failure(error):
                                promise(.failure(.error(error)))
                            case let .success(false):
                                promise(.success(true))
                            case let .success(true):
                                promise(.success(true))
                            }
                        })
                    } else {
                        // 토큰 유효성 체크 성공 (필요 시 토큰 갱신됨)
                    }
                }
            } else {
                // 토큰이 없는 상태 로그인 필요
//                kakaoLogin()
                self?.kakaoLogin(completion: { result in
                    switch result {
                    case let .failure(error):
                        promise(.failure(.error(error)))
                    case let .success(false):
                        promise(.success(true))
                    case let .success(true):
                        promise(.success(true))
                    }
                })
            }
        }.eraseToAnyPublisher()
    }
    
//    func checkKakaoToken()  -> AnyPublisher<Bool, ServiceError> {
//        // 카카오 토큰이 존재한다면
//            if AuthApi.hasToken() {
//                UserApi.shared.accessTokenInfo { accessTokenInfo, error in
//                    if let error = error {
//                        print("DEBUG: 카카오톡 토큰 가져오기 에러 \(error.localizedDescription)")
//                        self.kakaoLogin()
//                    } else {
//                        // 토큰 유효성 체크 성공 (필요 시 토큰 갱신됨)
//                    }
//                }
//            } else {
//                // 토큰이 없는 상태 로그인 필요
//                kakaoLogin()
//            }
//    }
    
    /// 로그인 실행
    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            signInWithKakaoApp() // 카카오톡 앱이 있다면 앱으로 로그인
        } else {
            signInWithKakaoWeb() // 앱이 없다면 웹으로 로그인 (시뮬레이터)
        }
    }
    
    /// 앱으로 카카오 로그인 진행
    func signInWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.signupWithFirebase()
                }
            }
        }
    }
    
    /// 웹으로 카카오 로그인 진행
    func signInWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.signupWithFirebase()
                }
            }
        }
    }
    
    /// Firebase에 이메일/비밀번호로 가입
    func signupWithFirebase() -> AnyPublisher<Bool, ServiceError> {
        Future { [weak self] promise in
            self?.signupWithFirebase { result in
                switch result {
                case let .success(true):
                    promise(.success(true))
                case .success(false):
                    promise(.success(true))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
//    func signupWithFirebase() {
//        UserApi.shared.me() { user, error in
//            if let error = error {
//                print("🟨 DEBUG: 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
//            } else {
//                print("🟨 DEBUG: 카카오톡 사용자 정보가져오기 success.")
//                
//                // 파이어베이스 유저 생성 (이메일로 회원가입)
//                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!,
//                                       password: "\(String(describing: user?.id))") { result, error in
//                    print("🟨 DEBUG: 카카오톡 사용자 정보로 파이어베이스 사용자 생성 성공")
//                    if let error = error {
//                        print("🟨 DEBUG: 파이어베이스 사용자 생성 실패 \(error.localizedDescription)")
//                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!,
//                                           password: "\(String(describing: user?.id))")
//                    } else {
//                        print("🟨 DEBUG: 파이어베이스 사용자 생성")
//                    }
//                }
//            }
//        }
//    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.error(error)))
            }
        }.eraseToAnyPublisher()
    }
    
    func logoutWithKakao() {
        UserApi.shared.logout { error in
            if let error {
                print("🟨 DEBUG: 카카오 로그아웃 중 에러 발생 \(error.localizedDescription)")
            } else {
                print("🟨 DEBUG: 카카오 로그아웃 성공")
            }
        }
    }
    
    // MARK: - 유저닉네임유무 확인하기!!!!!!!
//    func checkUserNickname(userID: String) -> String {
//        var checkDB: [DocumentSnapshot] = []
//        
//        Firestore.firestore().collection("User").getDocuments { querySnapshot, error in
//            if let error = error {
//                print("error!!!: \(error)")
//            } else {
//                if let documents = querySnapshot?.documents {
//                    checkDB.append(contentsOf: documents)
//                }
//            }
//        }
//    }
    
    func checkUserNickname(userID: String, completion: @escaping (Bool) -> Void) {
        var checkDB: [DocumentSnapshot] = []
        
        Firestore.firestore().collection("User").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error retrieving documents: \(error)")
                completion(false)
            } else {
                if let documents = querySnapshot?.documents {
                    checkDB.append(contentsOf: documents)
                    // Check if userID exists in checkDB
                    let userExists = checkDB.contains { $0.documentID == userID }
                    completion(userExists) // Call completion with the result
                } else {
                    completion(false) // Call completion with false if documents are nil
                }
            }
        }
    }
}

extension AuthenticationService {
    
    // apple login combine 제공x -> handler -> Publisher
    private func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, //credential 생성
                                                 nonce: String,
                                                 completion: @escaping (Result<User, Error>) -> Void) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken else {
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
        // idToken(Data type) -> String으로 타입 변환
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        // firebase에 인증하는 함수 실행해서 apple login 추가
        authenticateUserWithFirebase(credential: credential) { result in
            switch result {
            case var .success(user):
                user.name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                completion(.success(user))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func checkKakaoToken(completion: @escaping (Result<Bool, Error>) -> Void) {
        // 카카오 토큰이 존재한다면
            if AuthApi.hasToken() {
                UserApi.shared.accessTokenInfo { accessTokenInfo, error in
                    if let error = error {
                        print("DEBUG: 카카오톡 토큰 가져오기 에러 \(error.localizedDescription)")
                        completion(.failure(error))
                        self.kakaoLogin(completion: completion)
                    } else {
                        // 토큰 유효성 체크 성공 (필요 시 토큰 갱신됨)
                    }
                }
            } else {
                // 토큰이 없는 상태 로그인 필요
                completion(.success(true))
                kakaoLogin(completion: completion)
            }
    }
    
    func kakaoLogin(completion: @escaping (Result<Bool, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            signInWithKakaoApp(completion: completion) // 카카오톡 앱이 있다면 앱으로 로그인
        } else {
            signInWithKakaoWeb(completion: completion) // 앱이 없다면 웹으로 로그인 (시뮬레이터)
        }
    }
    
    /// 앱으로 카카오 로그인 진행
    func signInWithKakaoApp(completion: @escaping (Result<Bool, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.signupWithFirebase(completion: completion)
                    completion(.success(true))
                }
            }
        }
    }
    
    /// 웹으로 카카오 로그인 진행
    func signInWithKakaoWeb(completion: @escaping (Result<Bool, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.signupWithFirebase(completion: completion)
                    completion(.success(true))
                }
            }
        }
    }
    
    // MARK: - 카카오 로그인
    func signupWithFirebase(completion: @escaping (Result<Bool, Error>) -> Void) {
        UserApi.shared.me() { user, error in
            if let error = error {
                print("🟨 DEBUG: 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("🟨 DEBUG: 카카오톡 사용자 정보가져오기 success.")
                // 파이어베이스 유저 생성 (이메일로 회원가입)
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!,
                                       password: "\(String(describing: user?.id))") { result, error in
                    print("🟨 DEBUG: 카카오톡 사용자 정보로 파이어베이스 사용자 생성 성공")
                    if let error = error {
                        print("🟨 DEBUG: 파이어베이스 사용자 생성 실패 \(error.localizedDescription)")
                        completion(.failure(error))
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!,
                                           password: "\(String(describing: user?.id))")
                    } else {
                        print("🟨 DEBUG: 파이어베이스 사용자 생성")
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    
    /// Firebase 인증 함수, 'AuthCredential'(Google 로그인에서 획득)을 가져와 Firebase 인증 프로세스를 완료
    private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let result else {
                completion(.failure(AuthenticationError.invalidated))
                return
            }
            
            let firebaseUser = result.user
            // 추후 User 값 수정이 필요함
            let user: User = .init(id: firebaseUser.uid,
                                   name: firebaseUser.displayName ?? "",
                                   diary: nil) // 통신을 통한 diary 객체 값 전달 예정
            
            completion(.success(user))
        }
    }
}

// 프리뷰 용 프로토콜
class StubAuthenticationService: AuthenticationServiceType {
    
    func checkAuthenticationState() -> String? {
        return nil
    }

    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        return ""
    }
    
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError>  {
        Empty().eraseToAnyPublisher()
    }
    
//    func checkKakaoToken() { }
    func checkKakaoToken() -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    func signInWithKakaoApp() { }
    
    func signInWithKakaoWeb() { }
    
    func signupWithFirebase() -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func kakaoLogin() { }
    
    func logoutWithKakao() { }
    
    func checkUserNickname(userID: String, completion: @escaping (Bool) -> Void) { }
}
