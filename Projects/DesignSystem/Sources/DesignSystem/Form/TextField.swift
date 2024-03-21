//
//  TextField.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

public enum TFType {
    /// 일반 텍스트 필드(회원가입 시 닉네임 입력받기)
    case normal
    /// 닉네임 입력시 발생하는 오류
    case error
}

public struct CustomTextFieldStyle: ViewModifier {
    let type: TFType
    public func body(content: Content) -> some View {
        switch type {
        case .normal:
            content
                .padding(.vertical, 20)
                .padding(.leading, 20)
                .background(Color.gray1_F3F5F8)
                .font(.medium(14))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
        case .error:
            content
                .padding(.vertical, 20)
                .padding(.leading, 20)
                .font(.medium(14))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.buddhism_FF5959, lineWidth: 1)
                )
        }
    }
}

public extension TextField {
    func customTF(type: TFType) -> some View {
        self.modifier(CustomTextFieldStyle(type: type))
    }
}
