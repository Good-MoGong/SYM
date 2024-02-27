//
//  MyAccountInfo.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MyAccountInfo: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var nickname = UserDefaults.standard.string(forKey: "nickName") ?? "" // 기존 닉네임이 뜨도록
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.allow
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
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
                            TextField("아이디", text: $authViewModel.userEmail)
                                .customTF(type: .normal)
                                .disabled(true)
                            
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.kakao)
                                    .frame(width: .symWidth * 0.08)
                                
                                Image("KaKaoLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: .symWidth * 0.05)
                                    .clipped()
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    
                    Spacer()
                    
                    Button("완료") {
                        authViewModel.nickName = nickname
                        dismiss()
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6))
                    // disabled 추가해서 비활성화 가능
                    .disabled(1 > nickname.count || nickname.count >= 6)
                }
                .padding(.horizontal)
            }
            .font(PretendardFont.bodyBold)
            
            Spacer()
        }
        .navigationTitle("닉네임 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear(perform: {
            //            print("-----------------------")
            //            print(authViewModel.userEmail)
            //            print(authViewModel.loginInfo)
            //            print("-----------------------")
        })
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

//#Preview {
//    NavigationStack {
//        MyAccountInfo()
//    }
//}
