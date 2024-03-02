//
//  MyAccountInfo.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MyAccountInfo: View {
    private let loginProvider = UserDefaults.standard.string(forKey: "loginProvider")
    @State private var nickname: String = UserDefaults.standard.string(forKey: "nickname") ?? ""
    @State private var loginEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.allow
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("SimiSmile").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .symWidth * 0.4)
                    .padding(.top, 24)
                
                VStack {
                    VStack(alignment: .leading) {
                        //TODO: - 닉네임 글자수에 따른 조건 처리
                        Text("닉네임")
                            .padding(.leading, 20)
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
                            .padding(.leading, 20)
                            .font(PretendardFont.h5Bold)
                        
                        ZStack(alignment: .trailing) {
                            TextField("아이디", text: $loginEmail)
                                .customTF(type: .normal)
                                .disabled(true)
                            
                            userProviderLogo()
                                .padding(.trailing, 8)
                        }
                    }
                    
                    Spacer()
                    
                    Button("완료") {
                        UserDefaults.standard.set(nickname, forKey: "nickname")
                        dismiss()
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6 && nicknameRules == .allow))
                    // disabled 추가해서 비활성화 가능
                    .disabled(1 > nickname.count || nickname.count >= 6 || nicknameRules == .reject)
                }
                .padding(.horizontal)
            }
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
    
    @ViewBuilder
    func userProviderLogo()  -> some View {
        let imageSize: CGFloat = .symWidth * 0.05
        let circleSize: CGFloat = .symWidth * 0.08

        ZStack {
            Circle()
                .foregroundStyle(loginProvider == "Kakao" ? Color.kakao : Color.black)
                .frame(width: circleSize)
            
            if loginProvider == "Apple" {
                 Image("AppleLogo")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: .symWidth * 0.05)
                     .offset(x: -0.8, y: -0.5)
             } else {
                 Image("KaKaoLogo")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: imageSize)
             }
        }
    }
}

#Preview {
    NavigationStack {
        MyAccountInfo()
            .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
    }
}
