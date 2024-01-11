//
//  CommonBackground.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

public enum BackgroundType {
    case systemPink
    case grayThird
}

struct BackgroundView: ViewModifier {
    let type: BackgroundType
    func body(content: Content) -> some View {
        switch type {
        case .systemPink:
            content
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.symPink)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        case .grayThird:
            content
                .padding(20)
                .background(Color.symGray1)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}

struct UseforSignupView: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(PretendardFont.smallMedium)
            .foregroundColor(color)
            .lineSpacing(1.5)
    }
}

public extension Text {
    /// 일반 핑크/회색 백그라운드
    func setBackgroundColor(_ colorType: BackgroundType) -> some View {
        self.modifier(BackgroundView(type: colorType))
    }
    
    /// 회원가입시 닉네임 관련 modifier 일괄 적용
    func SignupTextFieldContent(color: Color) -> some View {
        self.modifier(UseforSignupView(color: color))
    }
}


