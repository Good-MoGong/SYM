//
//  MyAccountInfo.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MyAccountInfo: View {
    @State private var nickname = "모공모공"
    var body: some View {
        NavigationStack {
            VStack {
                Circle()
                    .foregroundStyle(Color.symGray2)
                    .frame(width: 100, height: 100)
                    .padding(.top, 24)
                    .padding(.bottom, 37)
                
                VStack {
                    VStack(alignment: .leading) {
                        //TODO: - 닉네임 글자수에 따른 조건 처리
                        Text("닉네임")
                            .padding(.leading, 20)
                            .font(PretendardFont.h5Bold)
                        
                        TextField("닉네임을 입력해주세요", text: $nickname)
                            .customTF(type: .normal)
                    }
                    .padding(.bottom, 32)
                    
                    VStack(alignment: .leading) {
                        Text("가입계정")
                            .padding(.leading, 20)
                            .font(PretendardFont.h5Bold)

                        
                        ZStack(alignment: .trailing) {
                            TextField("아이디", text: .constant("abcd123@kakako.com"))
                                .customTF(type: .normal)

                            Image(systemName: "message")
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
                    // .buttonStyle에 적용
                    // isButtonEnabled에 활성화/비활성화 되는 Bool 조건 넣어서 사용하면 됨!
                    .buttonStyle(MainButtonStyle(isButtonEnabled: nickname.isEmpty))
                    // disabled 추가해서 비활성화 가능
                    .disabled(nickname.isEmpty)
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
        })
    }
}

#Preview {
    NavigationStack {
        MyAccountInfo()
    }
}
