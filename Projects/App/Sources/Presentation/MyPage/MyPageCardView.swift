//
//  MyPageCardView.swift
//  SYM
//
//  Created by 변상필 on 3/7/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MyPageCardView: View {
    @State private var nickname: String = UserDefaultsKeys.nickname
    @State private var count: Int = CoreDataManger.shared.getDiaryCount()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                NavigationLink {
                    MyAccountInfo()
                } label: {
                    HStack {
                        Text("\(nickname)님")
                        Image(systemName: "chevron.right")
                            .font(.medium(18))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .font(.bold(18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 12)
                
                Text("\(count)개의 감정기록이 담겨있네요!\n시미가 당신의 의견을 기다리고 있어요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: true, vertical: false)
                    .lineSpacing(2)
                    .font(.medium(14))
                
                    Button {
                        if let url = URL(string: CustomerSupports.contactUs.rawValue) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("시미에게 의견 보내기")
                            .font(.bold(16))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.vertical, 14)
                    .frame(maxWidth: .symWidth * 0.5)
                    .background(Color.sub)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 10)
            }
            
            Spacer()
            
            Image("SimiCurious")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .symWidth * 0.3)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.bright)
        )
    }
}

#Preview {
    MyPageCardView()        
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}
