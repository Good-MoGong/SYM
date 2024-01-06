//
//  CustomTextField.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum TFType {
    /// 일반 텍스트 필드(회원가입 시 닉네임 입력받기)
    case normal
    /// 닉네임 입력시 발생하는 오류
    case error
}

struct CustomTextFieldStyle: ViewModifier {
    let type: TFType
    func body(content: Content) -> some View {
        switch type {
        case .normal:
            VStack {
                content
                    .padding(15)
                    .padding(.leading, 7)
                    .background(Color.symGray1)
                    .font(DesignSystem.FontStyles.symBody)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal, 5)
            }
        case .error:
            VStack(alignment: .leading, spacing: 8) {
                content
                    .padding(15)
                    .padding(.leading, 7)
                    .font(DesignSystem.FontStyles.symBody)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.red, lineWidth: 1)
                    )
                    .padding(.horizontal, 5)
                Text("사용할 수 없는 닉네임이에요 \n닉네임을 다시 한번 확인해주세요")
                    .font(DesignSystem.FontStyles.symSmall)
                    .foregroundColor(.red)
                    .lineSpacing(1.5)
                    .padding(.leading, 15)
            }
        }
    }
}

extension TextField {
    func customTF(type: TFType) -> some View {
        self.modifier(CustomTextFieldStyle(type: type))
    }
}
