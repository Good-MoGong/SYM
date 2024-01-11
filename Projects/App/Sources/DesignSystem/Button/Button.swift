//
//  Button.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct PinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.symBlack)
            // isPressed 통해 버튼 눌렸을 때 색 변경 구현
            .background(configuration.isPressed ? Color.symPressedPink : Color.symPink)
            .cornerRadius(30)
    }
}

struct DisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.symWhite)
            .background(Color.symGray2)
            .cornerRadius(30)
    }
}
