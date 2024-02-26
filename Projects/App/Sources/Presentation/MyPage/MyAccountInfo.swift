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
    
    @State private var nickname = "모공모공" // 기존 닉네임이 뜨도록
    @State var isPressed: Bool = false
    @State var nicknameRules = NickNameRules.allow
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("SimiSmile")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .scaledToFill()
                    .padding(.top, 24)
                    .padding(.bottom, 37)
                
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
                            TextField("아이디", text: .constant("abcd123@kakako.com"))
                                .customTF(type: .normal)
                                .disabled(true)
                            
                            Image("KaKaoLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 38, height: 32)
                                .clipped()
                                .padding(.trailing, 8) // 이미지와 텍스트 필드 간의 간격 조절
                        }
                    }
                    
                    Spacer()
                    
                    Button("완료") {
                        print("MainButtonStyle 버튼 눌림")
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

#Preview {
    NavigationStack {
        MyAccountInfo()
    }
}
