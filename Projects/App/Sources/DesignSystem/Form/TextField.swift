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
            content
                .padding(.vertical, 17)
                .padding(.leading, 20)
                .background(Color.symGray1)
                .font(PretendardFont.bodyMedium)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
        case .error:
            content
                .padding(.vertical, 17)
                .padding(.leading, 20)
                .font(PretendardFont.bodyMedium)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.errorRed, lineWidth: 1)
                )
        }
    }
}

extension TextField {
    func customTF(type: TFType) -> some View {
        self.modifier(CustomTextFieldStyle(type: type))
    }
}
