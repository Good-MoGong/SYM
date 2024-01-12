//
//  SettingView.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @State private var isShowingLogoutPopup = false
    @State private var isShowingWithdrawalPopup = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Toggle(isOn: .constant(true), label: {
                    Text("푸시 알림 설정")
                        .font(PretendardFont.h5Bold)
                })
                .tint(Color.symPink)
                .padding(.top, 44)
                .padding(.bottom, 50)
                
                HStack {
                    Button {
                        isShowingLogoutPopup.toggle()
                    } label: {
                        Text("로그아웃")
                            .font(PretendardFont.h5Bold)
                    }
                    Spacer()
                }
                .buttonStyle(.plain)
                .padding(.bottom, 10)
                
                HStack {
                    Button {
                        isShowingWithdrawalPopup.toggle()
                    } label: {
                        Text("회원탈퇴")
                            .font(PretendardFont.smallBold)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .customNavigationBar(centerView: {
            Text("설정")
        }, rightView: {
            EmptyView()
        })
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
