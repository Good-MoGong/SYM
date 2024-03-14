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
                Spacer().frame(height: 16)
                
//                Toggle(isOn: $settingViewModel.notificationToggle, label: {
//                    Text("푸시 알림 설정")
//                })
//                .tint(Color.main)

                                
                VStack(spacing: 30) {
//                    Text("테스트")
//                        .onTapGesture {
//                            print("🔑 UserDefaultsKeys.loginProvider: \(UserDefaultsKeys.loginProvider)")
//                            print("🔑 UserDefaultsKeys.loginProvider type: \(type(of: UserDefaultsKeys.loginProvider))")
//                            print("(userid) \(authViewModel.userId)")
//                        }
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
                        firebaseService.deleteDiarySubcollection(forUserID: userId) { result in
                            if result, UserDefaultsKeys.loginProvider == "Apple" {
                                authViewModel.send(action: .unlinkApple)
                                settingViewModel.isShowingWithdrawalPopup.toggle()
                            } else if result, UserDefaultsKeys.loginProvider == "Kakao" {
                                authViewModel.send(action: .unlinkKakao)
                                settingViewModel.isShowingWithdrawalPopup.toggle()
                            }
                        }
                    } else {
                        print("🔥 Firebase DEBUG: 회원가입 정보 없음, 유저 탈퇴 시 에러 발생")
                    }
            
                    authViewModel.progressImage = false
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
                    authViewModel.progressImage = false
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
