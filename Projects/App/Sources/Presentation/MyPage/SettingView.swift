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
    @State private var isShowingWithdrawalPopup = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 26) {
                Toggle(isOn: .constant(true), label: {
                    Text("푸시 알림 설정")
                })
                .tint(Color.main)
                .padding(.top, 32)
                
                Group {
                    HStack {
                        Button {
                            isShowingLogoutPopup.toggle()
                        } label: {
                            Text("로그아웃")
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
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                }
                .font(PretendardFont.h5Medium)
                .foregroundStyle(Color.symGray4)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .customNavigationBar(centerView: {
            Text("설정")
        }, rightView: {
            EmptyView()
        })
        .popup(isShowing: $isShowingWithdrawalPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: "로그아웃 하시겠어요?",
               boldDesc: "탈퇴 전 유의 사항",
               desc: "• 탈퇴 후 7일간은 재가입이 불가합니다. \n• 탈퇴 시 계정의 모든 정보는 삭제되며, \n   재가입후에도 복구 되지 않습니다.",
               confirmHandler: {
            print("확인")
            self.isShowingWithdrawalPopup.toggle()
        },
               cancelHandler: {
            print("취소 버튼")
            self.isShowingWithdrawalPopup.toggle()
        })
        .popup(isShowing: $isShowingLogoutPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: "로그아웃 하시겠어요?",
               boldDesc: "",
               desc: "") {
            self.isShowingLogoutPopup.toggle()
        } cancelHandler: {
            self.isShowingLogoutPopup.toggle()
        }
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}