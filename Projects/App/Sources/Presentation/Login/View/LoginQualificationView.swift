//
//  LoginPopupViewTest.swift
//  SYM
//
//  Created by 박서연 on 2024/02/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct LoginQualificationView: View {
    @State var personalToggle = false
    @State var termsConditionToggle = false
    @State var isShowing = true
    
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
                            .font(PretendardFont.h3Bold)
                            .foregroundColor(.symGray6)
                        Spacer().frame(height: 20)
                        VStack(spacing: 18) {
                            Rectangle()
                                .fill(Color.symGray3)
                                .frame(height: 1)
                            
                            CommonQualificaion(toggleValue: $personalToggle, title: "개인정보 처리방침 동의 (필수)", url: "https://www.naver.com/")
                            CommonQualificaion(toggleValue: $termsConditionToggle, title: "서비스 이용 약관 동의 (필수)", url: "https://www.naver.com/")
                        }
                        Spacer().frame(height: 30)
                        
                        Button {
                            isShowing.toggle()
                        } label: {
                            Text("완료")
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: termsConditionToggle && personalToggle))
                        .disabled(termsConditionToggle && personalToggle ? false : true)
                        Spacer().frame(height: 30)
                    }
                    .padding(.horizontal, 28)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 25)
                }
            }
            .opacity(isShowing ? 1 : 0)
            .animation(.easeIn, value: isShowing)
        }
    }
}

struct CommonQualificaion: View {
    @Binding var toggleValue: Bool
    let title: String
    let url: String
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                toggleValue.toggle()
            } label: {
                Image("checkGray")
                    .opacity(toggleValue ? 1 : 0.5)
            }
            Spacer().frame(width: 10)
            
            Text(title)
                .font(PretendardFont.h4Medium)
                .foregroundColor(.symGray6)
            Spacer()
            linkView("", url)
        }
    }
    
    private func rowView(_ label: String) -> some View {
        Image("chevronRight")
    }
    
    @ViewBuilder
    private func linkView(_ label: String, _ url: String) -> some View {
        if let url = URL(string: url) {
            Link(destination: url) {
                rowView(label)
            }
        }
    }
}

#Preview {
    LoginQualificationView()
}
