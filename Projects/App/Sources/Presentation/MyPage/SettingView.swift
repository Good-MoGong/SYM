//
//  SettingView.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    
    func removeAllUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

enum SettingConent: String {
    case logoutTitle = "로그아웃 하시겠어요?"
    case removeTitle = "탈퇴하시겠어요?"
    case removeBoldDesc = "탈퇴 전 유의 사항"
    case removeDesc = "• 탈퇴 후 7일간은 재가입이 불가합니다. \n• 탈퇴 시 계정의 모든 정보는 삭제되며, \n   재가입후에도 복구 되지 않습니다."
}

struct SettingView: View {
    @StateObject var settingViewModel = SettingViewModel()
    private let firebaseService = FirebaseService.shared
    
    @State private var isShowingLogoutPopup = false
    @State private var isShowingWithdrawalPopup = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 26) {
                Toggle(isOn: .constant(true), label: {
                    Text("푸시 알림 설정")
                })
                .tint(Color.main)
                .padding(.top, 32)
                
                VStack(spacing: 26) {
                    Button {
                        isShowingLogoutPopup.toggle()
                    } label: {
                        Text("로그아웃")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        isShowingWithdrawalPopup.toggle()
                    } label: {
                        Text("회원탈퇴")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .font(PretendardFont.h5Medium)
                .foregroundStyle(Color.symGray4)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .customNavigationBar(centerView: {
            Text("설정")
        }, rightView: {
            EmptyView()
        })
        
        .popup(isShowing: $isShowingWithdrawalPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: SettingConent.removeTitle.rawValue,
               boldDesc: SettingConent.removeBoldDesc.rawValue,
               desc: SettingConent.removeDesc.rawValue,
               confirmHandler: {
                    print("탈퇴하기")
                    
                    if let userId = authViewModel.userId {
                        // 이거는 애플 로그인 탈퇴
//                        firebaseService.deleteUserData(user: userId) { result in
//                            if result {
//                                authViewModel.send(action: .unlinkApple)
//                            }
//                        }
                        
                       // 이거는 카카오
                        firebaseService.deleteUserData(user: userId) { result in
                            if result {
                                authViewModel.send(action: .unlinkKakao)
                            }
                        }
                        
                        // 팝업 버튼 토글
                        self.isShowingWithdrawalPopup.toggle()
                        
                } else {
                    print("🔥 Firebase DEBUG: 회원가입 정보 없음, 유저 정보 삭제 시 에러 발생")
                }
            
        },
               cancelHandler: {
            print("취소 버튼")
            self.isShowingWithdrawalPopup.toggle()
        })
        
        .popup(isShowing: $isShowingLogoutPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: SettingConent.logoutTitle.rawValue,
               boldDesc: "",
               desc: "",
               confirmHandler: {
                    print("로그아웃")
            
//                    settingViewModel.removeAllUserDefaults() // userDefault 지우기
                    authViewModel.send(action: .logout) // 로그아웃
                    self.isShowingLogoutPopup.toggle()
            }, cancelHandler: {
                self.isShowingLogoutPopup.toggle()
            })
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
