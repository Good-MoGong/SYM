//
//  ButtonDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo
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

struct ButtonDemo: View {
    var body: some View {
        VStack {
            Button("디폴트 버튼 테스트용") {
                print("DefaultStyle 버튼 눌림")
            }
            /// .buttonStyle에 적용
            .buttonStyle(DefaultButtonStyle())
            
            Button("Disabled 버튼 테스트용") {
                print("DisabledStyle 버튼 눌림")
            }
            .buttonStyle(DisabledButtonStyle())
            
            /// 버튼 나란히 생성시
            HStack {
                Button("테스트용") {
                    print("DefaultStyle 버튼 눌림")
                }
                /// .buttonStyle에 적용
                .buttonStyle(DefaultButtonStyle())
                Button("테스트용") {
                    print("DisabledStyle 버튼 눌림")
                }
                .buttonStyle(DisabledButtonStyle())
            }
        }
        /// 버튼에 padding 값 따로 주지 않음. 버튼 사용시 padding 필요
        .padding(.horizontal, 20)
    }
}

#Preview {
    ButtonDemo()
}
