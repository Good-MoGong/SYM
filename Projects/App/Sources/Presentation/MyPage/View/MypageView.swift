//
//  Mypage.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

enum CustomerSupports: String {
    case termsCodition = "https://ballistic-dollar-2f4.notion.site/0afe47f5003f470d8b20adff3cc2abc5" // 이용약관
    case privacyPolicy = "https://ballistic-dollar-2f4.notion.site/820097f01cca4e929e189f925548071b" // 개인정보 처리방침
    case contactUs = "https://forms.gle/eojoJnDg2csmb9QS6" // 문의하기
}


struct MypageView: View {
    @StateObject var mypageViewModel = MypageViewModel()
    
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
        .onAppear {
            mypageViewModel.latestVersion()
        }
    }
    
    @ViewBuilder
    private func CustomerSupport() -> some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("고객지원")
                .font(.bold(20))
            
            CustomerSupportButton(buttonTitle: "리뷰 남기기", mypageViewModel: mypageViewModel)
            SettingViewLinker(title: "서비스 이용 약관", url: CustomerSupports.termsCodition.rawValue)
            SettingViewLinker(title: "개인정보처리방침", url: CustomerSupports.privacyPolicy.rawValue)
            
            HStack {
                Text("버전 정보")
                    .font(.medium(17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(mypageViewModel.nowVersion ?? "1.0")")
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
                .font(.medium(17))
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
    @ObservedObject var mypageViewModel: MypageViewModel
    
    var body: some View {
        Button {
            mypageViewModel.moveWritingReviews()
        } label: {
            HStack {
                Text("\(buttonTitle)")
                    .font(.medium(17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.forward")
                    .font(.medium(17))
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
