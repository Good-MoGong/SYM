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

// 인증 에러 정의
enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidated
}

// 인증을 담당할 서비스 생성 (Services에 연관된)
protocol AuthenticationServiceType {
    // 로그인 세션
    func checkAuthenticationState() -> String?
    
    // MARK: - Apple 로그인
    // 요청이 왔을 때 원하는 정보에 대한 범위를 request에 담아서 보내줌
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    // 인증에 대한 성공 정보와 로그인 요청에 대한 정보를 담고 있음
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError>
    
    // MARK: - 로그아웃
    func logout() -> AnyPublisher<Void, ServiceError>
    
}

class AuthenticationService: AuthenticationServiceType {
    // 파베를 사용해서 유저 정보 체크 후 유저 정보 추출하기
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
    
    // 완료된 작업 Futuer 생성
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
}

// 구글 로그인 컴바인 제공 x -> COMPLETION handler로 정의 후 컴바인 사용
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
    
    // 'AuthCredential'(Google 로그인에서 획득)을 가져와 Firebase 인증 프로세스를 완료
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
}
