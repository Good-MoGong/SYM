//
//  AuthenticatedView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/29.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import Combine

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    private let firebaseService = FirebaseService.shared
    var nickname: String = UserDefaultsKeys.nickname
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .initial:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .unauthenticated:
                LoginNicknameView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainView()
                    .environmentObject(authViewModel)
                    // FCM 관련 허용 여부 선택
                    .onAppear {
                        authViewModel.send(action: .requestPushNotification)
                    }
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: stubService())))
}
