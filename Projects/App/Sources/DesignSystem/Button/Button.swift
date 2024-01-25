//
//  Button.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

/// Default pink main button, 활성화 된 버튼
struct PinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 19)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.white)
            .background(Color.main)
            .cornerRadius(15)
    }
}

/// Sub pink button, 마이페이지에서 사용
struct SubPinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.white)
            .background(Color.sub)
            .cornerRadius(15)
    }
}

/// Disabled button, 비활성화 된 버튼
struct DisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 19)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.symGray5)
            .background(Color.symGray1)
            .cornerRadius(15)
    }
}

/// 작은 크기의 Gray button, 감정일기 기록 완료 시에 "홈" 버튼으로 사용
struct smallGrayButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 40)
            .padding(.vertical, 17)
            .font(PretendardFont.h3Medium)
            .foregroundColor(Color.symGray5)
            .background(Color.symGray1)
            .cornerRadius(15)
    }
}
