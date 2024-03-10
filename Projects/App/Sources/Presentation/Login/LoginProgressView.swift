//
//  ProgressView.swift
//  SYM
//
//  Created by 박서연 on 2024/03/10.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct LoginProgressView: View {
    var body: some View {
        VStack(spacing: 150) {
            
            MovingSimiView(image: "SimiLogin")
                .padding(.horizontal, 120)
            
            Text("만나서 만가워요! \n당신의 기록을 기다릴게요")
                .font(PretendardFont.bodyMedium)
                .tracking(0.5)
                .lineSpacing(5.0)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.bright)
                .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    LoginProgressView()
}
