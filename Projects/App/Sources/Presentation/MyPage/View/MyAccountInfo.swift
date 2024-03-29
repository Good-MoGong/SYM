//
//  MyAccountInfo.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

struct MyAccountInfo: View {
    @State private var nickname: String = UserDefaultsKeys.nickname
    @State private var loginEmail = UserDefaultsKeys.userEmail
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.allow
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let firebaseService: FirebaseService = FirebaseService.shared
    private let loginProvider = UserDefaultsKeys.loginProvider
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 30)
                
                Image("SimiFlower")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 100)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("닉네임")
                            .font(.bold(16))
                        
                        VStack(alignment: .leading) {
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
                    .padding(.bottom, 32)
                    
                    VStack(alignment: .leading) {
                        Text("가입계정")
                            .font(.bold(16))
                        UserProvider(userEmail: "\(loginEmail)")
                    }
                    
                    Spacer()
                    
                    Button("완료") {
                        print("\(nickname)")
                        Task {
                            await updateNickname()
                        }
                        UserDefaults.standard.set(nickname, forKey: "nickname")
                        dismiss()
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6 && nicknameRules == .allow))
                    .disabled(1 > nickname.count || nickname.count >= 6 || nicknameRules == .reject)
                }
            }
            .padding(.horizontal, 20)
            .font(.bold(14))
            
            Spacer()
        }
        .dismissKeyboardOnTap()
        .customNavigationBar(centerView: {
            Text("닉네임 수정")
        }, rightView: {
            EmptyView()
        }, isShowingBackButton: true)
    }
    
    private func updateNickname() async {
        do {
            try await firebaseService.updateUserNickname(userID: authViewModel.userId ?? "")
        } catch {
            print("\(error)")
        }
    }
    
    private func koreaLangCheck(_ input: String) -> Bool {
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

#Preview {
    NavigationStack {
        MyAccountInfo()
            .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
    }
}
