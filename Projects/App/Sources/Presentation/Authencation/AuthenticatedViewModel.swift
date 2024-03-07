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
    
    @Published var authenticationState: AuthenticationState = .initial
    @Published var userId: String?
    @Published var loginProvider: String = UserDefaultsKeys.loginProvider
    
    // MARK: - 프로그래스뷰 추가
    @Published var progressImage: Bool = false
    
    private var currentNonce: String?
    private var container: DIContainer
    private var subscritpions = Set<AnyCancellable>()
    private let firebaseService = FirebaseService.shared
    private var nickname: String = UserDefaultsKeys.nickname
    private let dataFetchManager = DataFetchManager.shared
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
            // 로그인 정보 확인하기
        case .checkAuthenticationState:
            self.progressImage = true
            
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                print("🔺 userID : \(userId)")
                // 지영 추가 - 받아온 userID로 data fetch
                Task {
                    await dataFetchManager.fetchData(userID: userId)
                    
                    DispatchQueue.main.async {
                        self.firebaseService.checkingUserNickname(userID: userId) { result in
                            if result {
                                self.progressImage = false
                                self.authenticationState = .authenticated
                            } else {
                                self.progressImage = false
                                self.authenticationState = .unauthenticated
                            }
                        }
                    }
                }
            } else {
                print("🔺Here is userID is nil \(userId ?? "유저 아이디 없어요")")
                print("🔺 유저 계정 상태 \(self.authenticationState)")
                self.progressImage = false
                self.authenticationState = .initial
            }
            
        case let .appleLogin(requeset):
            progressImage = true
            
            let nonce = container.services.authService.handleSignInWithAppleRequest(requeset)
            self.currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, none: nonce)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.progressImage = false
                        }
                    } receiveValue: { [weak self] user in
                        if let checkUser = self?.container.services.authService.checkAuthenticationState() {
                            print("🥶 애플 checkUser \(checkUser)")
                            
                            self?.firebaseService.checkingUserNickname(userID: checkUser) { result in
                                if result {
                                    print("🥶🥶 \(checkUser)")
                                    print("📛📛🍎 nickname Userdefault : \(UserDefaultsKeys.nickname)")
                                    
                                    self?.userId = checkUser
                                    // 지영 추가 - 첫 애플 로그인시에 타는 분기
                                    Task { [weak self] in
                                        // 강한참조 방지
                                        guard let self = self else { return }
                                        // fetchData 함수 비동기 호출
                                        await self.dataFetchManager.fetchData(userID: checkUser)
                                        self.container.services.authService.getUserLoginEmail()
                                        self.container.services.authService.getUserLoginProvider()
                                        DispatchQueue.main.async {
                                            self.progressImage = false
                                            self.authenticationState = .authenticated
                                        }
                                    }
                                    return
                                } else {
                                    self?.userId = checkUser
                                    self?.container.services.authService.getUserLoginEmail()
                                    self?.container.services.authService.getUserLoginProvider()
                                    DispatchQueue.main.async {
                                        self?.progressImage = false
                                        self?.authenticationState = .unauthenticated
                                    }
                                }
                            }
                        }
                    }.store(in: &subscritpions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
            
        case .kakaoLogin:
            self.progressImage = true
            
            container.services.authService.checkKakaoToken()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.progressImage = false
                    }
                } receiveValue: { [weak self] result in
                    if let checkUser = self?.container.services.authService.checkAuthenticationState() {
                        print("🥶 카카오 checkUser \(checkUser)")
                        self?.firebaseService.checkingUserNickname(userID: checkUser) { result in
                            print("📛📛 nickname Userdefault : \(UserDefaultsKeys.nickname)")
                            if result {
                                print("🥶🥶 \(checkUser)")
                                self?.userId = checkUser
                                // 지영 추가 - 첫 카카오 로그인시에 타는 분기
                                Task { [weak self] in
                                    // 강한참조 방지
                                    guard let self = self else { return }
                                    
                                    // fetchData 함수 비동기 호출
                                    await self.dataFetchManager.fetchData(userID: checkUser)
                                    self.container.services.authService.getUserLoginEmail()
                                    self.container.services.authService.getUserLoginProvider()
                                    DispatchQueue.main.async {
                                        self.progressImage = false
                                        self.authenticationState = .authenticated
                                    }
                                }
                                return
                            } else {
                                self?.userId = checkUser
                                self?.container.services.authService.getUserLoginEmail()
                                self?.container.services.authService.getUserLoginProvider()
                                DispatchQueue.main.async {
                                    self?.progressImage = false
                                    self?.authenticationState = .unauthenticated
                                }
                            }
                        }
                    }
                }.store(in: &subscritpions)
            
        case .requestPushNotification:
            container.services.pushNotificationService.requestAuthorization { granted in
                if granted {
                    // 알림 허용일 때 디폴트 알람 값 설정하기
                    // self.container.services.pushNotificationService.settingPushNotification() -> 일단 주석
                }
            }
            
            // 로그아웃
        case .logout:
            self.progressImage = true
            container.services.authService.logoutWithKakao()
            container.services.authService.logout()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.progressImage = false
                    }
                } receiveValue: { [weak self] _ in
                    self?.userId = nil
                    self?.container.services.authService.removeAllUserDefaults()
                    DispatchQueue.main.async {
                        self?.progressImage = false
                        self?.authenticationState = .initial
                    }
                }.store(in: &subscritpions)
            dataFetchManager.deleteCoreData()
            self.authenticationState = .initial
            
            
        case .unlinkKakao:
            self.progressImage = true
            
            firebaseService.deleteFriebaseAuth()
                .flatMap { _ in
                    self.container.services.authService.removeKakaoAccount()
                }
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.progressImage = false
                    }
                }, receiveValue: { [weak self] _ in
                    self?.container.services.authService.removeAllUserDefaults()
                    self?.dataFetchManager.deleteCoreData()
                    DispatchQueue.main.async {
                        self?.progressImage = false
                        self?.authenticationState = .initial
                    }
                })
                .store(in: &subscritpions)
            
        case .unlinkApple:
            self.progressImage = true
            
            firebaseService.deleteFriebaseAuth()
                .flatMap { _ in
                    self.container.services.authService.removeAppleAccount()
                }
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.progressImage = false
                    }
                }, receiveValue: { [weak self] _ in
                    self?.container.services.authService.removeAllUserDefaults()
                    self?.dataFetchManager.deleteCoreData()
                    DispatchQueue.main.async {
                        self?.progressImage = false
                        self?.authenticationState = .initial
                    }
                })
                .store(in: &subscritpions)
        }
    }
}
