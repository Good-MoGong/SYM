//
//  LoginModifier+LinkView.swift
//  SYM
//
//  Created by 박서연 on 2024/02/28.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct QualificationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 28)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 20)
            .padding(.bottom, 25)
    }
}

struct SignupBackground: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func customQualificationModifier() -> some View {
        self.modifier(QualificationModifier())
    }
    
    func signupTextBackground(_ color: Color) -> some View {
        self.modifier(SignupBackground(color: color))
    }
}

struct CommonQualificaion: View {
    @Binding var toggleValue: Bool
    let title: String
    let url: String
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                toggleValue.toggle()
            } label: {
                Image("checkGray")
                    .opacity(toggleValue ? 1 : 0.5)
            }
            Spacer().frame(width: 10)
            
            Text(title)
                .font(PretendardFont.h4Medium)
                .foregroundColor(.symGray6)
            Spacer()
            linkView("", url)
        }
    }
    
    private func rowView(_ label: String) -> some View {
        Image("chevronRight")
    }
    
    @ViewBuilder
    private func linkView(_ label: String, _ url: String) -> some View {
        if let url = URL(string: url) {
            Link(destination: url) {
                rowView(label)
            }
        }
    }
}
