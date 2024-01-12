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
                    .frame(width: 71, height: 71)
                    .padding(.top, 53)
                    .padding(.bottom, 41)
                
                VStack(alignment: .leading) {
                    HStack {
                        //TODO: - 닉네임 글자수에 따른 조건 처리
                        Text("닉네임")
                            .padding(.trailing, 37)
                        
                        TextField("", text: $nickname)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.symGray1)
                            .frame(height: 29)
                            .clearButton(text: $nickname)
                    }
                    .padding(.bottom, 41)
                    
                    HStack {
                        Text("가입계정")
                            .padding(.trailing, 37)
                        
                        Text("abc213445@kakao.com")
                            .tint(Color.symBlack)
                        
                        Spacer()
                        
                        Image(systemName: "message")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 38, height: 32)
                            .clipped()
                    }
                }
                .padding(.horizontal)
                .padding(.trailing, 54)
            }
            .font(PretendardFont.bodyBold)
            
            Spacer()
        }
        .customNavigationBar(centerView: {
            Text("닉네임 수정")
        }, rightView: {
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gearshape")
            }
        })
    }
}

#Preview {
    NavigationStack {
        MyAccountInfo()
    }
}
