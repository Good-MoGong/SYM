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
        case appleLoginCompletion(Result<ASAuthorization, Error>) // 인증이 된 후
        
        // 카카오로그인
//        case kakaoLogin
//        case kakaologout
        case logout
    }
    
    @Published var isLoading = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    // userId를 받아서 닉네임 설정 뷰로 넘어가고, 해당 뷰에서 닉넴이과 합쳐서 create firestore해야함
//    @Published var userInfo: User?
    @Published var userId: String?
//    var userId: String?
    
    private var currentNonce: String?
    private var container: DIContainer
    private var subscritpions = Set<AnyCancellable>()
    
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
                self.authenticationState = .authenticated
            }
            
            // 애플로그인 진행 -> 인증 요청
        case let .appleLogin(requeset): // ASAuthorizationAppleIDRequest라는 연관값을 request로써 사용하기 위해서 바인딩 진행
            let nonce = container.services.authService.handleSignInWithAppleRequest(requeset)
            self.currentNonce = nonce
            
            // 애플로그인 완료 -> 인증 결과
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, none: nonce)
                    .sink { [weak self] completion in // 생성자에게 구독증 신청
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id // firebase auth의 유저별 ID
                        self?.authenticationState = .authenticated
                    
                    }.store(in: &subscritpions) // 리턴되는 구독증 관리
                
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
            
            // 로그아웃
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
