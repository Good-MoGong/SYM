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
                NavigationStack {
                    LoginNicknameView()
                        .environmentObject(authViewModel)
                }
            case .authenticated:
                MainView()
                    .environmentObject(authViewModel)
//                TabBarView(tabBarViewModel: tabBarViewModel)
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
