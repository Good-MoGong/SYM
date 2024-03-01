//
//  AuthenticatedViewModel.swift
//  SYM
//
//  Created by 박서연 on 2024/01/29.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import Combine
import AuthenticationServices
import FirebaseAuth
import SwiftUI

// 인증 상태에 따른 분기처리
enum AuthenticationState {
    case initial
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    enum Action {
        case checkAuthenticationState
        case appleLogin(ASAuthorizationAppleIDRequest) // 인증 요청할때
        case appleLoginCompletion(Result<ASAuthorization, Error>) // 인증이 된 후
        case kakaoLogin
        case requestPushNotification
        case logout
        case unlinkKakao
        case unlinkApple
    }
    
    @Published var isLoading = false
    @Published var authenticationState: AuthenticationState = .initial
    @Published var userId: String?
    @Published var loginProvider: String = (UserDefaults.standard.string(forKey: "loginProvider") ?? "")
    
    private var currentNonce: String?
    private var container: DIContainer
    private var subscritpions = Set<AnyCancellable>()
    private let firebaseService = FirebaseService.shared
    private var nickname: String = UserDefaults.standard.string(forKey: "nickname") ?? ""
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
            // 로그인 정보 확인하기
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                print("🔺 userID : \(userId)")
                firebaseService.checkingUserNickname(userID: userId) { result in
                    if result {
                        self.authenticationState = .authenticated
                    } else {
                        self.authenticationState = .unauthenticated
                    }
                }
            } else {
                print("🔺Here is userID is nil \(userId ?? "유저 아이디 없어요")")
                print("🔺 유저 계정 상태 \(self.authenticationState)")
                self.authenticationState = .initial
            }
            
        case let .appleLogin(requeset):
            let nonce = container.services.authService.handleSignInWithAppleRequest(requeset)
            self.currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, none: nonce)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        if let checkUser = self?.container.services.authService.checkAuthenticationState() {
                            print("🥶 애플 checkUser \(checkUser)")
                            
                            self?.firebaseService.checkingUserNickname(userID: checkUser) { result in
                                if result {
                                    print("🥶🥶 \(checkUser)")
                                    self?.userId = checkUser
                                    self?.authenticationState = .authenticated
                                    self?.container.services.authService.getUserLoginEmail()
                                    self?.container.services.authService.getUserLoginProvider()
                                    return
                                } else {
                                    self?.userId = checkUser
                                    self?.authenticationState = .unauthenticated
                                    self?.container.services.authService.getUserLoginEmail()
                                    self?.container.services.authService.getUserLoginProvider()
                                }
                            }
                        }
                    }.store(in: &subscritpions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
            
        case .kakaoLogin:
            container.services.authService.checkKakaoToken()
                .sink { completion in
                    //
                } receiveValue: { [weak self] result in
                    if let checkUser = self?.container.services.authService.checkAuthenticationState() {
                        print("🥶 카카오 checkUser \(checkUser)")
                        self?.firebaseService.checkingUserNickname(userID: checkUser) { result in
                            if result {
                                print("🥶🥶 \(checkUser)")
                                self?.userId = checkUser
                                self?.authenticationState = .authenticated
                                self?.container.services.authService.getUserLoginEmail()
                                self?.container.services.authService.getUserLoginProvider()
                                
                                return
                            } else {
                                self?.userId = checkUser
                                self?.authenticationState = .unauthenticated
                                self?.container.services.authService.getUserLoginEmail()
                                self?.container.services.authService.getUserLoginProvider()
                                
                            }
                        }
                    }
                }.store(in: &subscritpions)
            
        case .requestPushNotification:
            container.services.pushNotificationService.requestAuthorization { granted in
                if granted {
                    // 알림 허용일 때 디폴트 알람 값 설정하기
                    self.container.services.pushNotificationService.settingPushNotification()
                }
            }
            
            // 로그아웃
        case .logout:
            container.services.authService.logoutWithKakao()
            container.services.authService.logout()
                .sink { completion in
                    //
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .initial
                    self?.userId = nil
                    self?.container.services.authService.removeAllUserDefaults()
                }.store(in: &subscritpions)
            self.authenticationState = .initial
            
            
        case .unlinkKakao:
            firebaseService.deleteFriebaseAuth()
                .flatMap { _ in
                    self.container.services.authService.removeKakaoAccount()
                }
                .sink(receiveCompletion: { completion in
                    //
                }, receiveValue: { _ in
                    self.authenticationState = .initial
                    self.container.services.authService.removeAllUserDefaults()
                })
                .store(in: &subscritpions)
            
        case .unlinkApple:
            firebaseService.deleteFriebaseAuth()
                .flatMap { _ in
                    self.container.services.authService.removeAppleAccount()
                }
                .sink(receiveCompletion: { completion in
                    //
                }, receiveValue: { _ in
                    self.authenticationState = .initial
                    self.container.services.authService.removeAllUserDefaults()
                })
                .store(in: &subscritpions)
        }
    }
}
