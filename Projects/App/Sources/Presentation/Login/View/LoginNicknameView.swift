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
    case reject = "특수문자는 사용이 불가능해요"
}

struct LoginNicknameView: View {
    @State private var nickname = ""
    @State private var isPressed: Bool = false
    @State private var user: User = .init(id: "", name: "")
    @State private var nicknameRules = NickNameRules.defult
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    private let firebaseService = FirebaseService.shared
    
    var body: some View {
        NavigationStack {
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
        }
        .padding(24)
        .navigationTitle("닉네임 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func doneButton() -> some View {
        Button {
            // currentUser 정보로 변경
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
        let allowedCharacters = CharacterSet.alphanumerics
        return string.components(separatedBy: allowedCharacters.inverted).joined()
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
        //        LoginNicknameView()
        //            .environmentObject(AuthenticationViewModel(container: .init(services: Services())))
        //        LoginNicknameView(authViewModel: AuthenticationViewModel(container: .init(services: Services())))
    }
}
