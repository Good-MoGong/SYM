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
            VStack(alignment: .leading, spacing: 8) {
                content
                    .padding(.vertical, 20)
                    .padding(.leading, 30)
                    .background(Color.symGray1)
                    .font(PretendardFont.bodyMedium)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                Text("한글, 영문을 포함하여 최소 2~5자까지 입력 가능해요. \n닉네임은 가입 후에도 바꿀 수 있어요.")
                    .font(PretendardFont.bodyMedium)
                    .foregroundColor(.black)
                    .lineSpacing(1.5)
                    .padding(.leading, 15)
            }
        case .error:
            VStack(alignment: .leading, spacing: 8) {
                content
                    .padding(.vertical, 20)
                    .padding(.leading, 30)
                    .font(PretendardFont.bodyMedium)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.red, lineWidth: 1)
                    )
                /// 잠시 레거시..
//                Text("사용할 수 없는 닉네임이에요 \n닉네임을 다시 한번 확인해주세요")
//                    .font(PretendardFont.smallMedium)
//                    .foregroundColor(.red)
//                    .lineSpacing(1.5)
//                    .padding(.leading, 15)
            }
        }
    }
}

extension TextField {
    func customTF(type: TFType) -> some View {
        self.modifier(CustomTextFieldStyle(type: type))
    }
}
