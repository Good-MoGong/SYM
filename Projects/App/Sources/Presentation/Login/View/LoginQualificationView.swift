//
//  LoginPopupViewTest.swift
//  SYM
//
//  Created by 박서연 on 2024/02/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

enum Qualification: String {
    case personal = "https://ballistic-dollar-2f4.notion.site/820097f01cca4e929e189f925548071b" // 개인정보 처리방침
    case termsCodition =  "https://ballistic-dollar-2f4.notion.site/0afe47f5003f470d8b20adff3cc2abc5" // 이용약관
}

class LoginQualificationViewModel: ObservableObject {
    @Published var personalToggle = false
    @Published var termsConditionToggle = false
    @Published var isShowing = true
}

struct LoginQualificationView: View {
    @StateObject var loginQualificationViewModel = LoginQualificationViewModel()
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
        }
        .overlay {
            ZStack(alignment: .bottom) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    VStack(alignment: .leading) {
                        Spacer().frame(height: 40)
                        Text("약관에 동의해주세요")
                            .font(.bold(18))
                            .foregroundColor(.symGray6)        
                        Spacer().frame(height: 20)
                        
                        VStack(spacing: 18) {
                            Rectangle()
                                .fill(Color.symGray3)
                                .frame(height: 1)
                            
                            CommonQualificaion(toggleValue: $loginQualificationViewModel.personalToggle,
                                               title: "개인정보 처리방침 동의 (필수)", 
                                               url: Qualification.personal.rawValue)
                            
                            CommonQualificaion(toggleValue: $loginQualificationViewModel.termsConditionToggle,
                                               title: "서비스 이용 약관 동의 (필수)", 
                                               url: Qualification.termsCodition.rawValue)
                        }
                        Spacer().frame(height: 30)
                        
                        Button {
                            loginQualificationViewModel.isShowing.toggle()
                        } label: {
                            Text("완료")
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: loginQualificationViewModel.termsConditionToggle && loginQualificationViewModel.personalToggle))
                        .disabled(loginQualificationViewModel.termsConditionToggle && loginQualificationViewModel.personalToggle ? false : true)
                        
                        Spacer().frame(height: 30)
                    }
                    .customQualificationModifier()
                }
            }
            .opacity(loginQualificationViewModel.isShowing ? 1 : 0)
            .animation(.easeIn, value: loginQualificationViewModel.isShowing)
        }
    }
}



#Preview {
    LoginQualificationView()
}
