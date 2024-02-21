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
    case defult = "한글, 영문을 포함하여 최대 5자까지 입력 가능해요."
    case reject = "특수문자와 숫자는 사용이 불가능해요"
}

struct LoginNicknameView: View {
    @State private var nickname = ""
    @State private var isPressed: Bool = false
    @State private var user: User = .init(id: "", name: "")
    @State private var nicknameRules = NickNameRules.defult
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    private let firebaseService = FirebaseService.shared
    
    @State private var containsSpecialCharacter = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("환영해요! \n닉네임을 입력해주세요")
                        .font(PretendardFont.h3Medium)
                        .lineSpacing(8)
                    
                    VStack(alignment: .leading, spacing: 13) {
                        TextField("닉네임을 입력해주세요", text: $nickname)
                            .customTF(type: .normal)
                            .onChange(of: nickname) { newValue in
                                if koreaLangCheck(newValue) {
                                    nicknameRules = .allow
                                } else {
                                    nicknameRules = .reject
                                }
                                if newValue.count > 5 || newValue.count < 1 {
                                    nicknameRules = .defult
                                }
                            }
                                    
                        switch nicknameRules {
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
            // 유저 정보 닉네임까지 받아서 firestore에 추가
            if let userID = Auth.auth().currentUser?.uid {
                user.id = userID
                user.name = nickname
                user.diary = []
                firebaseService.createUserInFirebase(user: user)
            }
            
            // home으로 페이지 이동
            withAnimation(.easeInOut) {
                authViewModel.authenticationState = .authenticated
            }
        } label: {
            Text("완료")
                .font(PretendardFont.h4Medium)
        }
        .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6))
        .disabled(1 > nickname.count || nickname.count >= 6)
    }
    
    func koreaLangCheck(_ input: String) -> Bool {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: input.utf16.count)
            if regex.firstMatch(in: input, options: [], range: range) != nil {
                return true
            }
        }
        return false
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

#Preview {
    NavigationStack {
        LoginNicknameView()
    }
}

extension Text {
    /// 회원가입시 닉네임 관련 modifier 일괄 적용
    func settingNicknameRules(_ color: Color) -> some View {
        self.modifier(SignupNickNameRuleView(color: color))
    }
}
