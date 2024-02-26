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
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError>
    func checkKakaoToken() -> AnyPublisher<User, ServiceError>
    func logout() -> AnyPublisher<Void, ServiceError>
    func logoutWithKakao()
    func checkUserNickname(userID: String, completion: @escaping (Bool) -> Void)
    
    // MARK: - 카카오톡 탈퇴 구현하기
    func unlinkKakao()
    
    // 파베에서 유저 삭제
    func deleteFirebaseAuth()
}

class AuthenticationService: AuthenticationServiceType {
    func checkAuthenticationState() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        return nonce
    }
    
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError> {
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

    /// 카카오 로그인 시작점
    func checkKakaoToken() -> AnyPublisher<User, ServiceError> {
        Future { [weak self] promise in
            self?.checkKakaoToken { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
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
    
    /// 닉네임 유저 유무 확인해서 바로 홈으로 보낼지 말지 확인
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
    
    
    // MARK: - 카카오톡 탈퇴
    /// 카카오톡 탈퇴
    func unlinkKakao() {
        UserApi.shared.unlink { error in
            if let error = error {
                print("🟨 Auth DEBUG: 카카오톡 탈퇴 중 에러 발생 \(error.localizedDescription)")
            } else {
                print("🟨 Auth DEBUG: 카카오톡 탈퇴 성공")
            }
        }
    }
    
    /// 파베의 auth에서 유저 정보 삭제
    func deleteFirebaseAuth() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("🔥 Firebase DEBUG: firebase auth에서 회원 삭제 중 에러 발생 \(error.localizedDescription)")
                } else {
                    print("🔥 Firebase DEBUG: firebase auth에서 회원 삭제 성공")
                }
            }
        } else {
            print("🔥 Firebase DEBUG: firebase auth에 회원정보가 존재하지 않습니다.")
        }
    }
}

extension AuthenticationService {
    
    private func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, //credential 생성
                                                 nonce: String,
                                                 completion: @escaping (Result<User, Error>) -> Void) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken else {
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
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
    
    /// Firebase 인증 함수, 'AuthCredential'(Google 로그인에서 획득)을 가져와 Firebase 인증 프로세스를 완료
    private func authenticateUserWithFirebase(credential: AuthCredential,
                                              completion: @escaping (Result<User, Error>) -> Void) {
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
    
    // MARK: - 카카오 로그인 시작점
    func checkKakaoToken(completion: @escaping (Result<User, Error>) -> Void) {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { accessTokenInfo, error in
                if let error = error {
                    print("🟨 DEBUG: KakaoTalk token retrieval error \(error.localizedDescription)")
                    self.kakaoLogin(completion: completion)
                } else {}
            }
        } else {
            self.kakaoLogin(completion: completion)
        }
    }
    
    func kakaoLogin(completion: @escaping (Result<User, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            signInWithKakaoApp(completion: completion) // 카카오톡 앱이 있다면 앱으로 로그인
        } else {
            signInWithKakaoWeb(completion: completion) // 앱이 없다면 웹으로 로그인 (시뮬레이터)
        }
    }
    
    /// 앱으로 카카오 로그인 진행
    func signInWithKakaoApp(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print("🟨 DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("🟨 DEBUG: 카카오톡 토큰 \(token)")
                    self.signupWithFirebase(completion: completion)
                }
            }
        }
    }
    
    /// 웹으로 카카오 로그인 진행
    func signInWithKakaoWeb(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("🟨 DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("🟨 DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("🟨 DEBUG: 카카오톡 토큰 \(token)")
                    self.signupWithFirebase(completion: completion)
                }
            }
        }
    }
    
    // MARK: - 카카오 로그인
    func signupWithFirebase(completion: @escaping (Result<User, Error>) -> Void) {
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
                        print("🟨 DEBUG: 파이어베이스 사용자 생성 실패 로그인 진행 \(error.localizedDescription)")
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { reult, error in
                            if let error = error {
                                completion(.failure(error))
                            } else if let userTest = reult {
                                print("🥵 user Uid: \(userTest.user.uid)")
                                let user: User = .init(id: userTest.user.uid, name: "")
                                completion(.success(user))
                            }
                        }
                    } else {
                        print("🟨 DEBUG: 파이어베이스 사용자 생성")
                        guard let result else { return }
                        let user: User = .init(id: result.user.uid, name: "")
                        completion(.success(user))
                    }
                }
            }
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
    
    func checkKakaoToken() -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func kakaoLogin() { }
    
    func logoutWithKakao() { }
    
    func checkUserNickname(userID: String, completion: @escaping (Bool) -> Void) { }
    
    func unlinkKakao() { }
    
    func deleteFirebaseAuth() { }
}
