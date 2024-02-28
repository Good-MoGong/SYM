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
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image("RecordBackground")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    Image("SimiSmile")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 50)
                        .modifier(CloudFloatingAnimation(offset: yOffset))
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                                self.yOffset = 10
                            }
                        }
                    VStack(spacing: 4) {
                        Text("SYM")
                            .foregroundColor(Color.main)
                            .font(PretendardFont.bold30)
                        Text("Speak Your Mind")
                            .foregroundColor(.sub)
                            .font(PretendardFont.h3Bold)
                    }
                    .foregroundColor(.main)
                }
                
                Spacer().frame(height: 130)
                
                VStack(spacing: 12) {
                    Button {
                        authViewModel.send(action: .kakaoLogin)
                    } label: {
                        HStack(spacing: 35) {
                            Image("KaKaoLogo")
                                .padding(.leading, 47)
                            Text("카카오톡으로 로그인")
                                .font(PretendardFont.h4Medium)
                                .foregroundColor(.symBlack)
                        }
                        .signupTextBackground(Color.kakao)
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
                        .signupTextBackground(.black)
                        .blendMode(.overlay)
                    }
                }
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    LoginIntroView()
}

struct CloudFloatingAnimation: GeometryEffect {
    var offset: CGFloat = 0

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: offset))
    }
}
