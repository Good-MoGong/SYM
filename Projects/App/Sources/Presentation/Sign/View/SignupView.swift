//
//  SignDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//
import SwiftUI

struct SignupView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Image("Sample")

                
                VStack(spacing: 4) {
                    Text("SYM")
                        .font(PretendardFont.h1Bold)
                    Text("Speak Your Mind")
                        .font(PretendardFont.h2Medium)
                }
                .foregroundColor(.main)
            }
            Spacer()
            VStack(spacing: 20) {
                Button {
                    print("🟨 카카오톡 로그인 진행")
                } label: {
                    HStack(spacing: 35) {
                        Image("KaKaoLogo")
                            .padding(.leading, 47)
                        Text("카카오톡으로 로그인")
                            .font(PretendardFont.h4Medium)
                            .foregroundColor(.symBlack)
                    }.signupTextBackground(Color.kakao)
                }
                
                Button {
                    print("🍎 애플 로그인 진행")
                } label: {
                    HStack(spacing: 35) {
                        Image("AppleLogo")
                            .padding(.leading, 47)
                        Text("Apple로 로그인")
                            .font(PretendardFont.h4Medium)
                            .foregroundColor(.white)
                    }.signupTextBackground(.symBlack)
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
    SignupView()
}
