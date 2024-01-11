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
        VStack(spacing: 150) {
            VStack(spacing: 20) {
                Circle()
                    .frame(width: 145, height: 145)
                
                VStack(spacing: 1) {
                    Text("SYM")
                        .font(PretendardFont.h1Bold)
                    Text("speak your mind")
                        .font(PretendardFont.h2Medium)
                }
            }
            
            VStack(spacing: 20) {
                HStack(spacing: 35) {
                    Image(systemName: "star.fill")
                        .padding(.leading, 35)
                    Text("카카오톡으로 로그인")
                        .font(PretendardFont.h4Medium)
                }.signupTextBackground(Color(hex: "FEE500"))
                
                HStack(spacing: 35) {
                    Image(systemName: "heart.fill")
                        .padding(.leading, 35)
                    Text("Apple로 로그인")
                        .font(PretendardFont.h4Medium)
                        .foregroundColor(.white)
                }.signupTextBackground(.symBlack)
            }
        }
        .padding(.horizontal, 24)
    }
}

/// 카카오톡과 애플 로그인 텍스트의 공통 background
struct SignupBackground: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

extension View {
    func signupTextBackground(_ color: Color) -> some View {
        self.modifier(SignupBackground(color: color))
    }
}

#Preview {
    SignupView()
}
