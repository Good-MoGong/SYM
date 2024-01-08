//
//  SignupNicknameView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/09.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct SignupNicknameView: View {
    @State var nickname = ""
    @State var isPressed: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("환영해요! \n회원님을 어떻게 불러드리면 좋을까요?")
                    .font(PretendardFont.h4Bold)
                    .lineSpacing(8)

                VStack(alignment: .leading, spacing: 10) {
                    TextField("닉네임을 입력해주세요", text: $nickname)
                        .customTF(type: nickname.count < 5 ? .normal : .error)
                    getTextField()
                }
            }
            Spacer()
            getButton()
            
        }
        .padding(24)
        .navigationTitle("닉네임 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func getButton() -> some View {
        if 1 <= nickname.count, nickname.count < 6 {
            Button("완료") {
                print("완료")
            }
            .buttonStyle(PinkButtonStyle())
        } else {
            Button("완료") {
                print("비활성화된 버튼 눌림")
            }
            .buttonStyle(DisabledButtonStyle())
        }
    }
    
    @ViewBuilder
    func getTextField() -> some View {
        if nickname.count >= 5 {
            HStack(alignment: .top) {
                Text("사용할 수 없는 닉네임이에요 \n닉네임을 다시 한번 확인해주세요")
                    .font(PretendardFont.smallMedium)
                    .foregroundColor(.red)
                    .lineSpacing(1.5)
                    .padding(.leading, 15)
                Spacer()
                HStack(spacing: 0) {
                    Text("\(nickname.count)")
                        .font(PretendardFont.smallMedium)
                        .foregroundColor(Color.symBlack)
                    Text("/5")
                        .font(PretendardFont.smallMedium)
                        .foregroundColor(Color.symGray4)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignupNicknameView()
    }
}
