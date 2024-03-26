//
//  SplashView.swift
//  SYM
//
//  Created by 박서연 on 2024/03/03.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @State private var rotationAngle: Double = 0
    @State private var message: String = "어서와요\n오늘 하루도 수고했어요"
    @State private var animatedMessage: String = ""
    @State private var isShowingMainView = false
    
    var body: some View {
        ZStack {
            Image("Splash")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Spacer().frame(height: 100)
                
                Text("진짜 내 마음을 말하는 일기장")
                    .font(.bold(18))
                    .foregroundColor(.sub)
                Text("SYM")
                    .font(.bold(50))
                    .foregroundColor(.main)
                
                Spacer()
                MovingSimiView(image: "SimiLogin")
                    .padding(.horizontal, 120)
                
                Spacer()
                
                Text(message)
                    .font(.medium(14))
                    .tracking(0.5)
                    .lineSpacing(5.0)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.bright)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                
                Spacer().frame(height: 150)
            }
        }
    }
}

#Preview {
    SplashView()
}
