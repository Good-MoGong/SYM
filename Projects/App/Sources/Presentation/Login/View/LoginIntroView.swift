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
    private var nickname: String = UserDefaultsKeys.nickname
    
    var body: some View {
        ZStack {
            Image("RecordBackground")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    MovingSimiView(image: "SimiLogin")
                        .padding(.horizontal, 80)
                    
                    VStack(spacing: 4) {
                        Text("SYM")
                            .foregroundColor(Color.main)
                            .font(.bold(30))
                        Text("Speak Your Mind")
                            .foregroundColor(.sub)
                            .font(.bold(20))
                    }
                    .foregroundColor(.main)
                }
                
                Spacer().frame(height: 130)
                
                VStack(spacing: 12) {
                    Button {
                        authViewModel.send(action: .kakaoLogin)
                    } label: {
                        HStack(spacing: 6) {
                            Image("KaKaoLogo")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.leading, .symWidth * 0.17)
                            Text("카카오톡으로 로그인")
                                .font(.medium(17))
                                .foregroundColor(.symBlack)
                        }
                        .signupTextBackground(Color.kakao)
                    }
                    
                    HStack(spacing: 6) {
                        Image("AppleLogo")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, .symWidth * 0.17)
                        Text("Apple로 로그인")
                            .font(.medium(17))
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

extension View {
    func animationSimi(yOffset: CGFloat) -> some View {
        self.modifier(AnimationSimi(yOffset: yOffset))
    }
}

struct AnimationSimi: ViewModifier {
    @State var yOffset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .modifier(CloudFloatingAnimation(offset: yOffset))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.7).repeatForever()) {
                    self.yOffset = 10
                }
            }
    }
}
