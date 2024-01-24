//
//  SignupNicknameView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/09.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum NickNameRules: String, CaseIterable {
    case zero = "한글, 영문을 포함하여 2~5자까지 입력 가능해요. \n닉네임은 가입 후에도 바꿀 수 있어요."
    case allow = "한글, 영문을 포함하여 최소 2~5자까지 입력 가능해요."
    case reject = "사용할 수 없는 닉네임이에요 \n닉네임을 다시 한번 확인해주세요"
}

struct SignupNicknameView: View {
    @State var nickname = ""
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.zero
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("환영해요! \n회원님을 어떻게 불러드리면 좋을까요?")
                    .font(PretendardFont.h4Bold)
                    .lineSpacing(8)

                VStack(alignment: .leading, spacing: 10) {
                    TextField("닉네임을 입력해주세요", text: $nickname)
                        .customTF(type: nickname.count < 5 ? .normal : .error)
                    checkNicknameRules()
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
    private func getButton() -> some View {
        if 1 <= nickname.count, nickname.count < 6 {
            Button {
                
            } label: {
                Text("완료")
                    .font(PretendardFont.h4Medium)
            }
            .buttonStyle(PinkButtonStyle())
            
        } else {
            Button(action: {}, label: {
                Text("완료")
                    .font(PretendardFont.h4Medium)
            })
            .buttonStyle(DisabledButtonStyle())
        }
    }
    
    @ViewBuilder
    /// 닉네임 규칙 룰을 그리는 뷰
    private func checkNicknameRules() -> some View {
        if nickname.isEmpty {
            Text(NickNameRules.zero.rawValue)
                .settingNicknameRules(.symBlack)
        } else if nickname.count < 5, nickname.count >= 1 {
            HStack {
                Text(NickNameRules.allow.rawValue)
                    .settingNicknameRules(.symBlack)
                countingNickname()
            }
        } else if nickname.count >= 5 {
            HStack(alignment: .top) {
                Text(NickNameRules.reject.rawValue)
                    .settingNicknameRules(.errorRed)
                countingNickname()
            }
        }
    }
    
    @ViewBuilder
    /// 닉네임 카운팅
    private func countingNickname() -> some View {
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

struct SignupNickNameRuleView: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(PretendardFont.smallMedium)
            .foregroundColor(color)
            .lineSpacing(1.5)
    }
}

extension Text {
    /// 회원가입시 닉네임 관련 modifier 일괄 적용
    func settingNicknameRules(_ color: Color) -> some View {
        self.modifier(SignupNickNameRuleView(color: color))
    }
}

#Preview {
    NavigationStack {
        SignupNicknameView()
    }
}
