//
//  Mypage.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MypageView: View {
    var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return version
    }
    
    var body: some View {
        NavigationStack {
            RecordView(isShowingMainView: false, nickname: nickname)
                .padding(.vertical, 25)

            CustomerSupport()
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationTitle("마이페이지")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    @ViewBuilder
    private func CustomerSupport() -> some View {
        VStack(alignment: .leading) {
            Text("고객지원")
                .font(PretendardFont.h3Bold)
                .padding(.bottom, 28)
            
            VStack {
                CustomerSupportButton(buttonTitle: "리뷰 남기기")
                CustomerSupportButton(buttonTitle: "서비스 이용 약관")
                CustomerSupportButton(buttonTitle: "개인정보처리방침")
            }
            
            HStack {
                Text("버전 정보")
                    .font(PretendardFont.h4Bold)
                Spacer()
                
                Text(appVersion ?? "0.0")
                    .font(PretendardFont.bodyBold)
            }
        }
        .padding(.trailing, 16)
        .foregroundStyle(Color.symBlack)
    }
}

private struct CustomerSupportButton: View {
    let buttonTitle: String
    var body: some View {
        Button {
            print(buttonTitle)
        } label: {
            HStack {
                Text("\(buttonTitle)")
                    .font(PretendardFont.h5Bold)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(PretendardFont.h4Medium)
            }
            .padding(.bottom, 26)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        MypageView()
            .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
    }
}
