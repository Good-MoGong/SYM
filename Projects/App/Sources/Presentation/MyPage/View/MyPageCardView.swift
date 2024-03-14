//
//  MyPageCardView.swift
//  SYM
//
//  Created by 변상필 on 3/7/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MyPageCardView: View {
    @AppStorage("nickname") private var nickname = ""
    @State private var count: Int = 0
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
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
                
                Text("\(count)개의 감정기록이 담겨있네요!\n시미가 당신의 의견을 기다리고 있어요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(7)
                    .font(.medium(12))
                    .padding(.vertical, 7)
                
                    Button {
                        if let url = URL(string: CustomerSupports.contactUs.rawValue) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("시미에게 의견 보내기")
                            .font(.bold(16))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.vertical, 11)
                    .frame(maxWidth: .symWidth * 0.5)
                    .background(Color.sub)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            Image("SimiCurious")
                .resizable()
                .scaledToFit()
                .frame(width: .symWidth * 0.3, height: .symWidth * 0.3)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.bright)
        )
        .onAppear {
            count = CoreDataManger.shared.getDiaryCount()
        }
    }
}

#Preview {
    MyPageCardView()        
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}
