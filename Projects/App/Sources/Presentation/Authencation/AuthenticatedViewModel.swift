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

// 인증 상태에 따른 분기처리
enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    enum Action {
        case checkAuthenticationState
        // 연관값 사용
        case appleLogin(ASAuthorizationAppleIDRequest) // 인증 요청할때
        case appleLoginCompletion(Result<ASAuthorization, Error>)// 인증이 된 후
        case logout
    }
    
    @Published var isLoading = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    var userId: String?
    private var currentNonce: String?
    private var container: DIContainer
    private var subscritpions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
            }
        case let .appleLogin(requeset): // ASAuthorizationAppleIDRequest라는 연관값을 request로써 사용하기 위해서 바인딩 진행
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
                        self?.isLoading = false
                        self?.userId = user.id
                        self?.authenticationState = .authenticated
                    }.store(in: &subscritpions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    //
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscritpions)
        }
    }
}
