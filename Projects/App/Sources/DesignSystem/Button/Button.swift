//
//  Button.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

/// Default main button, isButtonEnabled 변수에 Bool 값 지정해서 활성화/비활성화 함께 사용 가능
struct MainButtonStyle: ButtonStyle {
    
    var isButtonEnabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .font(.medium(18))
            .foregroundColor(isButtonEnabled ? Color.white : Color.symGray5)
            .background(isButtonEnabled ? Color.main : Color.symGray1)
            .cornerRadius(15)
    }
}

/// Sub pink button, 마이페이지에서 사용
struct SubPinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .font(.medium(20))
            .foregroundColor(Color.white)
            .background(Color.sub)
            .cornerRadius(15)
    }
}

/// 작은 크기의 Gray button, 감정일기 기록 완료 시에 "홈" 버튼으로 사용, 비활성화처럼 보이나 활성화된 버튼으로 사용
struct smallGrayButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 40)
            .padding(.vertical, 17)
            .font(.medium(20))
            .foregroundColor(Color.symGray5)
            .background(Color.symGray1)
            .cornerRadius(15)
    }
}

struct CustomButtonStyle: ButtonStyle {
    private let content: (ButtonStyle.Configuration) -> AnyView

    init<S: ButtonStyle>(_ style: S) {
        content = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        content(configuration)
    }
}
