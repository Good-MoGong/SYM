//
//  SettingView.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var isShowingLogoutPopup = false
    @Published var isShowingWithdrawalPopup = false
    @Published var notificationToggle = false
}

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var settingViewModel = SettingViewModel()
    
    private let firebaseService = FirebaseService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 26) {
                Spacer().frame(height: 30)
                
                Toggle(isOn: $settingViewModel.notificationToggle, label: {
                    Text("푸시 알림 설정")
                })
                .tint(Color.main)

                                
                VStack(spacing: 26) {
                    Button {
                        settingViewModel.isShowingLogoutPopup.toggle()
                    } label: {
                        Text("로그아웃").frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        settingViewModel.isShowingWithdrawalPopup.toggle()
                    } label: {
                        Text("회원탈퇴").frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .font(.medium(17))
                .foregroundStyle(Color.symGray4)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .customNavigationBar(centerView: {
            Text("설정")
        }, rightView: {
            EmptyView()
        }, isShowingBackButton: true)
      
        .popup(isShowing: $settingViewModel.isShowingWithdrawalPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: PopupContent.remove.title,
               desc: PopupContent.remove.desc,
               confirmHandler: {
                    if let userId = authViewModel.userId {
                        if authViewModel.loginProvider == "Apple" {
                            firebaseService.deleteUserData(user: userId) { result in
                                if result {
                                    authViewModel.send(action: .unlinkApple)
                                }
                            }
                        } else {
                             firebaseService.deleteUserData(user: userId) { result in
                                 if result {
                                     authViewModel.send(action: .unlinkKakao)
                                 }
                             }
                        }
                        
                        settingViewModel.isShowingWithdrawalPopup.toggle()
                    } else {
                        print("🔥 Firebase DEBUG: 회원가입 정보 없음, 유저 정보 삭제 시 에러 발생")
                    }
        },
               cancelHandler: {
                    settingViewModel.isShowingWithdrawalPopup.toggle()
        })
        
        .popup(isShowing: $settingViewModel.isShowingLogoutPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: PopupContent.logout.title,
               desc: PopupContent.logout.title,
               confirmHandler: {
                    print("로그아웃")
                    authViewModel.progressImage = true
                    authViewModel.send(action: .logout)
                    settingViewModel.isShowingLogoutPopup.toggle()
            }, cancelHandler: {
                    settingViewModel.isShowingLogoutPopup.toggle()
            })
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
