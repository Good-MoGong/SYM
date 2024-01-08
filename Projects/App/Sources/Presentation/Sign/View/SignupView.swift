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
            
            VStack(spacing: 30) {
                HStack(spacing: 35) {
                    Image(systemName: "star.fill")
                        .padding(.leading, 35)
                    Text("카카오톡으로 로그인")
                        .font(PretendardFont.h4Medium)
                }.loginCustom(.yellow)
                
                HStack(spacing: 35) {
                    Image(systemName: "heart.fill")
                        .padding(.leading, 35)
                    Text("Apple로 로그인")
                        .font(PretendardFont.h4Medium)
                        .foregroundColor(.white)
                }.loginCustom(.symBlack)
            }
        }
        .padding(.horizontal, 24)
    }
}

/// background 관련 디자인 빼기
struct CustomRoundedPaddingModifier: ViewModifier {
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
    func loginCustom(_ color: Color) -> some View {
        self.modifier(CustomRoundedPaddingModifier(color: color))
    }
}

#Preview {
    SignupView()
}
