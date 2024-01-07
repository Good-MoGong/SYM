//
//  Button.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 60)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.symBlack)
            .background(Color.symPink)
            .cornerRadius(30)
        // isPressed 통해 버튼 눌렸을 때 opacity 변경 -> pressed 시에 변경사항 협의 후 변경예정(-)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct DisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 60)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.symWhite)
            .background(Color.symGray2)
            .cornerRadius(30)
    }
}
