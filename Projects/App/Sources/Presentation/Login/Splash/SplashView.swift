//
//  SplashView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/29.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("Sample")
            VStack(spacing: 4) {
                Text("SYM")
                    .font(PretendardFont.h1Bold)
                Text("Speak Your Mind")
                    .font(PretendardFont.h2Medium)
            }
            .foregroundColor(.main)
        }
    }
}

#Preview {
    SplashView()
}
