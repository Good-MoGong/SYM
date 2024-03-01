//
//  MyAccountInfo.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MyAccountInfo: View {
    
    @State private var nickname = UserDefaultsKeys.nickname
    @State private var loginEmail = UserDefaultsKeys.userEmail
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.allow
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let loginProvider = UserDefaultsKeys.loginProvider
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 30)
                
                Image("SimiSmile").resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 95)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("닉네임")
                            .font(PretendardFont.h5Bold)
                        
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
                            .font(PretendardFont.h5Bold)
                        UserProvider(userEmail: "\(loginEmail)", providerType: authViewModel.loginProvider)
                    }
                    
                    Spacer()
                    
                    Button("완료") {
                        UserDefaults.standard.set(nickname, forKey: "nickname")
                        dismiss()
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6 && nicknameRules == .allow))
                    .disabled(1 > nickname.count || nickname.count >= 6 || nicknameRules == .reject)
                }
            }
            .padding(.horizontal, 20)
            .font(PretendardFont.bodyBold)
            
            Spacer()
        }
        
        .customNavigationBar(centerView: {
            Text("닉네임 수정")
        }, rightView: {
            EmptyView()
        }, isShowingBackButton: true)
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
