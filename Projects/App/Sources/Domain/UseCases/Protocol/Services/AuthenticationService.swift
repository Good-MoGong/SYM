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
    func checkAuthenticationState() -> String?
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError>
    func checkKakaoToken() -> AnyPublisher<User, ServiceError>
    func logout() -> AnyPublisher<Void, ServiceError>
    func logoutWithKakao()
    func removeAllUserDefaults()
    func removeKakaoAccount() -> AnyPublisher<Void, Error>
    func removeAppleAccount() -> AnyPublisher<Void, Error>
    
    // 계정정보
    func getUserLoginProvider()
    func getUserLoginEmail()
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
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }


    // MARK: - 카카오톡 로그인 AuthenticationServiceType 구현
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
    
    // MARK: - 로그아웃 AuthenticationServiceType 구현
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
    
    // MARK: - 탈퇴 AuthenticationServiceType 구현
    func removeKakaoAccount() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.removeKakaoAccount { result in
                if result {
                    promise(.success(()))
                } else {
                    promise(.failure(() as! Error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func removeAppleAccount() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.removeAppleAccount { result in
                if result {
                    promise(.success(()))
                } else {
                    promise(.failure(() as! Error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - UserDefault 관련 AuthenticationServiceType 구현
    func removeAllUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

// MARK: - 로그아웃 및 탈퇴 extenstion
extension AuthenticationService {
    func removeAppleAccount(completion: @escaping (Bool) -> Void) {
        let token = UserDefaults.standard.string(forKey: "refreshToken")
        
        if let token = token {
            let url = URL(string: "https://us-central1-speakyourmind-5001b.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard data != nil else { return }
                print("🍎 APPLE DEBUG: 탈퇴 성공 !! ")
            }
            task.resume()
        }
        
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("🍎 APPLE DEBUG: Apple 탈퇴/로그아웃 에러 발생 \(signOutError.localizedDescription)")
            completion(false)
        }
    }
    
    
    func removeKakaoAccount(completion: @escaping (Bool) -> Void) {
        UserApi.shared.unlink { error in
            if let error = error {
                print("🟨 Auth DEBUG: 카카오톡 탈퇴 중 에러 발생 \(error.localizedDescription)")
                completion(false)
            } else {
                print("🟨 Auth DEBUG: 카카오톡 탈퇴 성공")
                completion(true)
            }
        }
    }
}

// MARK: - Apple 로그인 및 및 파베 계정 생성 extension
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
        
        if let authorizationCode = appleIDCredential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
            let url = URL(string: "https://us-central1-speakyourmind-5001b.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error as NSError? {
                    print("🍎 APPLE DEBUG 토큰 에러 발생 : \(error.localizedDescription)")
                } else {
                    if let data = data {
                        let refreshToken = String(data: data, encoding: .utf8) ?? ""
                        
                        // token -> userDefault에 저장
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.synchronize()
                        print("🍎 APPLE DEBUG: 성공!")
                    } else {
                        print("🍎 APPLE DEBUG: refreshToken 없음")
                    }
                }
            }
            task.resume()
        }
        
        
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
                                   name: firebaseUser.displayName ?? "")
            
            completion(.success(user))
        }
    }
}

// MARK: - 카카오 로그인 시작점 extenstion
extension AuthenticationService {
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
            signInWithKakaoApp(completion: completion)
        } else {
            signInWithKakaoWeb(completion: completion)
        }
    }
    
    /// 앱으로 카카오 로그인 진행
    func signInWithKakaoApp(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
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

// MARK: - 유저 로그인 및 계정정보 extenstion
extension AuthenticationService {
    
    func getUserLoginProvider() {
        var provider: String = ""
        
        if let user = Auth.auth().currentUser {
            if let providerData = user.providerData.first {
                let providerID = providerData.providerID
            
                switch providerID {
                case "google.com":
                    provider = "Google"
                
                case "apple.com":
                    provider = "Apple"
                
                case "password":
                    provider = "Kakao"
                
                default:
                    provider = "Unknown"
                }
                
                print("🔥 Firebase DEBUD: 로그인 정보 \(provider)")
                UserDefaults.standard.set(provider, forKey: "loginProvider")
            }
        } else {
            print("🔥 Firebase DEBUD: 로그인 로그인 정보 없음")
        }
    }
    
    func getUserLoginEmail() {
        var email: String = ""
        
        if let user = Auth.auth().currentUser {
            if let emailData = user.email {
                email = emailData
                print("🔥 Firebase DEBUD: 유저 메일 정보  \(email)")
                UserDefaults.standard.set(email, forKey: "userEmail")
            }
        } else {
            print("🔥 Firebase DEBUD: 로그인한 유저 없음")
        }
    }
}

// 프리뷰 용 프로토콜
class StubAuthenticationService: AuthenticationServiceType {
    func checkAuthenticationState() -> String? { return nil }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String { return "" }
    
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError> { Empty().eraseToAnyPublisher() }
    
    func logout() -> AnyPublisher<Void, ServiceError>  { Empty().eraseToAnyPublisher() }
    
    func checkKakaoToken() -> AnyPublisher<User, ServiceError> { Empty().eraseToAnyPublisher() }
    
    func kakaoLogin() { }
    
    func logoutWithKakao() { }
    
    func checkUserNickname(userID: String, completion: @escaping (Bool) -> Void) { }

    func removeKakaoAccount() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }

    func removeAppleAccount() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }

    func deleteFirebaseAuth() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }

    func removeAllUserDefaults() { }
    
    func getUserLoginProvider() { }
    
    func getUserLoginEmail() { }
}
