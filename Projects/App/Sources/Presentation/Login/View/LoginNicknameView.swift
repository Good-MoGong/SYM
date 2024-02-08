//
//  SignupNicknameView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/09.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Combine

enum NickNameRules: String, CaseIterable {
    case allow = "사용가능한 닉네임이에요"
    case defult = "한글, 영문을 포함하여 최대 5자까지 입력 가능해요."
    case reject = "특수문자는 사용이 불가능해요"
}

struct LoginNicknameView: View {
    @State var nickname = ""
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.defult
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("환영해요! \n닉네임을 입력해주세요")
                    .font(PretendardFont.h4Medium)
                    .lineSpacing(8)
                
                VStack(alignment: .leading, spacing: 10) {
                    TextField("닉네임을 입력해주세요", text: $nickname, onEditingChanged: { editing in
                        if !editing {
                            nickname = removeSpecialCharacters(from: nickname)
                        }
                    })
                        .customTF(type: .normal)
                    checkNicknameRules()
                }
            }
            Spacer()
            doneButton()
            
            // 로그아웃 임시 버튼
            Button{
                authViewModel.send(action: .logout)
            } label: {
                Text("로그아웃")
            }
            
        }
        .padding(24)
        .navigationTitle("닉네임 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func doneButton() -> some View {
        Button {
            //
        } label: {
            Text("완료")
                .font(PretendardFont.h4Medium)
        }
        .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6))
        .disabled(1 > nickname.count || nickname.count >= 6)
    }
    
    @ViewBuilder /// 닉네임 규칙 룰을 그리는 뷰
    private func checkNicknameRules() -> some View {
        if nickname.isEmpty {
            Text(NickNameRules.defult.rawValue)
                .settingNicknameRules(.errorRed)
        } else if nickname.count <= 5, nickname.count >= 1 {
            HStack {
                Text(NickNameRules.allow.rawValue)
                    .settingNicknameRules(.errorGreen)
            }
        } else if nickname.count > 5 {
            HStack(alignment: .top) {
                Text(NickNameRules.defult.rawValue)
                    .settingNicknameRules(.errorRed)
            }
        }
    }
    
    func removeSpecialCharacters(from string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics // Set of allowed characters
        return string.components(separatedBy: allowedCharacters.inverted).joined() // Remove characters not in the set
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
        LoginNicknameView(authViewModel: AuthenticationViewModel(container: .init(services: Services())))
    }
}
