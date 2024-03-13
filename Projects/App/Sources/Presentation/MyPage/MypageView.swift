//
//  Mypage.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum CustomerSupports: String {
    case termsCodition = "https://docs.google.com/document/d/1IhIdE4TMgSdfjTtyTqx22sDhFQduehvqeKDbQPMaW7Y/edit?usp=sharing"
    case privacyPolicy = "https://docs.google.com/document/d/1bumoRR722rVVHGAdlT8wDsnP0E_IKFeWttAe-u4t2w0/edit?usp=sharing"
    case contactUs = "https://forms.gle/eojoJnDg2csmb9QS6"
}


struct MypageView: View {
    
    var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return version
    }
    
    var body: some View {
        NavigationStack {
            MyPageCardView()
            Spacer().frame(height: 25)
            CustomerSupport()
            Spacer()
        }
        .padding(.horizontal, 20)
        .customNavigationBar(centerView: {
            Text("마이페이지")
        }, rightView: {
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gearshape")
                    .foregroundStyle(.black)
            }
        }, isShowingBackButton: false)
    }
    
    @ViewBuilder
    private func CustomerSupport() -> some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("고객지원")
                .font(.bold(20))
            
            CustomerSupportButton(buttonTitle: "리뷰 남기기") // 앱스토어로 이동
            SettingViewLinker(title: "서비스 이용 약관", url: CustomerSupports.termsCodition.rawValue)
            SettingViewLinker(title: "개인정보처리방침", url: CustomerSupports.privacyPolicy.rawValue)
            
            HStack {
                Text("버전 정보")
                    .font(.medium(17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(appVersion ?? "0.0")
                    .font(.bold(14))
            }
        }
        .foregroundStyle(Color.symBlack)
    }
}

// 링크로 이동 뷰
struct SettingViewLinker: View {
    let title: String
    let url: String
    
    var body: some View {
            linkView("", url)
    }
    
    private func rowView(_ label: String) -> some View {
        HStack {
            Text("\(title)")
                .font(.medium(17))
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.forward")
                .font(PretendardFont.h4Medium)
        }
        .foregroundColor(.symBlack)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private func linkView(_ label: String, _ url: String) -> some View {
        if let url = URL(string: url) {
            Link(destination: url) {
                rowView(label)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

// 리뷰 남기기
private struct CustomerSupportButton: View {
    let buttonTitle: String
    var body: some View {
        Button {
            print(buttonTitle)
        } label: {
            HStack {
                Text("\(buttonTitle)")
                    .font(.medium(17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.forward")
                    .font(PretendardFont.h4Medium)
            }
            .foregroundColor(.symBlack)
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
