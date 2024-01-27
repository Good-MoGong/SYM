//
//  ButtonDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import SwiftUI

struct ButtonDemo: View {
    
    @State var text: String = ""
    
    var body: some View {
        VStack {
            // MainButtonStyle 사용 예시
            VStack {
                TextField("내용을 입력해주세요.", text: $text)
                    .customTF(type: .normal)
                
                Button("메인 버튼 테스트용") {
                    print("MainButtonStyle 버튼 눌림")
                }
                // .buttonStyle에 적용
                // isButtonEnabled에 활성화/비활성화 되는 Bool 조건 넣어서 사용하면 됨!
                .buttonStyle(MainButtonStyle(isButtonEnabled: !text.isEmpty))
                // disabled 추가해서 비활성화 가능
                .disabled(text.isEmpty)
            }
            .padding(.bottom, 30)
            
            
            Button("시미에게 의견 보내기") {
                print("SubPinkButton 버튼 눌림")
            }
            .buttonStyle(SubPinkButtonStyle())
            
            // 버튼 나란히 생성시
            HStack {
                Button("홈") {
                    print("smallGrayButton 버튼 눌림")
                }
                // .buttonStyle에 적용
                .buttonStyle(smallGrayButtonStyle())
                // 버튼 사이 간격 20
                .padding(.trailing, 20)
                
                Button("기록 보기") {
                    print("기록보기 버튼 눌림")
                }
                .buttonStyle(MainButtonStyle(isButtonEnabled: true))
            }
        }
        /// 버튼에 padding 값 따로 주지 않음. 버튼 사용시 padding 필요
        .padding(.horizontal, 20)
    }
}

#Preview {
    ButtonDemo()
}
