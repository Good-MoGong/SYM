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
import FirebaseAuth

enum NickNameRules: String, CaseIterable {
    case allow = "사용가능한 닉네임이에요"
    case defult = "한글, 영문을 포함하여 최대 5자까지 입력 가능해요"
    case reject = "특수문자와 숫자는 사용이 불가능해요"
}

struct LoginNicknameView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var loginNicknameViewModel = LoginNicknameViewModel()
    @State private var nickname: String = UserDefaults.standard.string(forKey: "nickname") ?? ""
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("환영해요! \n닉네임을 입력해주세요")
                        .font(PretendardFont.h3Medium)
                        .lineSpacing(8)
                    
                    VStack(alignment: .leading, spacing: 13) {
                        TextField("닉네임을 입력해주세요", text: $loginNicknameViewModel.nickname)
                            .customTF(type: .normal)
                            .onChange(of: loginNicknameViewModel.nickname) { newValue in
                                if loginNicknameViewModel.koreaLangCheck(newValue) {
                                    loginNicknameViewModel.nicknameRules = .allow
                                } else {
                                    loginNicknameViewModel.nicknameRules = .reject
                                }
                                if newValue.count > 5 || newValue.count < 1 {
                                    loginNicknameViewModel.nicknameRules = .defult
                                }
                            }
                                    
                        switch loginNicknameViewModel.nicknameRules {
                        case .allow :
                            Text(NickNameRules.allow.rawValue)
                                .settingNicknameRules(.errorGreen)
                        case .defult:
                            Text(NickNameRules.defult.rawValue)
                                .settingNicknameRules(.errorRed)
                        case .reject:
                            Text(NickNameRules.reject.rawValue)
                                .settingNicknameRules(.errorRed)
                        }
                    }
                }
                Spacer()
                doneButton()
            }
        }
        .padding(24)
        .navigationTitle("닉네임 설정")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            LoginQualificationView()
        }
    }
    
    @ViewBuilder
    private func doneButton() -> some View {
        Button {
            loginNicknameViewModel.addNicknametoFirebase()
            UserDefaults.standard.set(loginNicknameViewModel.nickname, forKey: "nickname")
            print("🔅 DEBUG: Nickname UserDefault에 재저장")
            
            withAnimation(.easeInOut) {
                authViewModel.authenticationState = .authenticated
            }
        } label: {
            Text("완료")
                .font(PretendardFont.h4Medium)
        }
        .buttonStyle(MainButtonStyle(isButtonEnabled: loginNicknameViewModel.nicknameRules == .allow))
        .disabled(1 > loginNicknameViewModel.nickname.count || loginNicknameViewModel.nickname.count >= 6)
    }
    
    
}

struct SignupNickNameRuleView: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(PretendardFont.bodyMedium)
            .foregroundColor(color)
            .lineSpacing(1.5)
    }
}

extension Text {
    func settingNicknameRules(_ color: Color) -> some View {
        self.modifier(SignupNickNameRuleView(color: color))
    }
}

#Preview {
    NavigationStack {
        LoginNicknameView()
    }
}
