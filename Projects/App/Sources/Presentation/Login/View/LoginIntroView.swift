//
//  SignDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//
import SwiftUI
import AuthenticationServices

struct LoginIntroView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var tabBarViewModel: TabBarViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Image("SimiSmile")
                        .resizable()
                        .padding(.horizontal, 70)
                        .scaledToFit()
                    VStack(spacing: 4) {
                        Text("SYM")
                            .foregroundColor(Color.main)
                            .font(PretendardFont.h1Bold)
                        Text("Speak Your Mind")
                            .foregroundColor(.main)
                            .font(PretendardFont.bold18)
                    }
                    .foregroundColor(.main)
                }
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        print("🟨 카카오톡 로그인 진행")
                        authViewModel.send(action: .kakaoLogin)
                    } label: {
                        HStack(spacing: 35) {
                            Image("KaKaoLogo")
                                .padding(.leading, 47)
                            Text("카카오톡으로 로그인")
                                .font(PretendardFont.h4Medium)
                                .foregroundColor(.symBlack)
                        }.signupTextBackground(Color.kakao)
                    }
                    
                    HStack(spacing: 35) {
                        Image("AppleLogo")
                            .padding(.leading, 47)
                        Text("Apple로 로그인")
                            .font(PretendardFont.h4Medium)
                            .foregroundColor(.white)
                    }
                    .signupTextBackground(.black)
                    .overlay {
                        SignInWithAppleButton(
                            onRequest: { request in
                                authViewModel.send(action: .appleLogin(request))
                            },
                            onCompletion: { result in
                                authViewModel.send(action: .appleLoginCompletion(result))
                            }
                        )
                        .blendMode(.overlay)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        Spacer()
    }
}

/// 카카오톡과 애플 로그인 텍스트의 공통 background
struct SignupBackground: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 19)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    /// 카카오톡과 애플 로그인 텍스트의 공통 background 설정
    func signupTextBackground(_ color: Color) -> some View {
        self.modifier(SignupBackground(color: color))
    }
}

#Preview {
    LoginIntroView()
}
