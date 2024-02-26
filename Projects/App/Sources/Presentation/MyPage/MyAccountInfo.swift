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
                            checkNicknameRules()
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
    
    @ViewBuilder
    /// 닉네임 규칙 룰을 그리는 뷰
    private func checkNicknameRules() -> some View {
        if nickname.isEmpty {
            Text(NickNameRules.defult.rawValue)
                .settingNicknameRules(.errorRed)
        } else if nickname.count < 6, nickname.count >= 1 {
            HStack {
                Text(NickNameRules.allow.rawValue)
                    .settingNicknameRules(.errorGreen)
            }
        } else if nickname.count >= 5 {
            HStack(alignment: .top) {
                Text(NickNameRules.defult.rawValue)
                    .settingNicknameRules(.errorRed)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyAccountInfo()
    }
}
