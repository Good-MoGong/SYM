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
//    @StateObject private var tabBarViewModel = TabBarViewModel()
    
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
//                TabBarView(tabBarViewModel: tabBarViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
        
        // MARK: - 다른거 뷰 실기기 테스트하고 돌아오는 경우 사용하는 로그아웃 버튼
//        Button {
//            authViewModel.send(action: .logout)
//            print("ddd")
//        } label: {
//            Text("로그아웃")
//        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: stubService())))
}
