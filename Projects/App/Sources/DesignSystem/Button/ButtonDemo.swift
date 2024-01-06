//
//  ButtonDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo
import SwiftUI

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
