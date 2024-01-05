//
//  FontDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import SwiftUI

struct DesignSystem {
    static let primaryButtonColor = Color.blue
    static let primaryButtonTextColor = Color.white
}

// 확인 예제
struct FontTest: View {
    var body: some View {
        VStack {
            Text("H1 Text")
//             둘 중 하나의 방법으로 사용
                .foregroundStyle(DesignSystem.ColorStyles.symGray1)
                .font(DesignSystem.FontStyles.symH1)
//              .modifier(PinkTextStyle())
//              .modifier(H1TextStyle())
            
            Text("H2 Text")
                .foregroundStyle(DesignSystem.ColorStyles.symGray4)
                .modifier(H2TextStyle())

            Text("Body Text")
                .foregroundStyle(DesignSystem.ColorStyles.symPink)
//                .foregroundStyle(Color.symPink)
                .modifier(BodyTextStyle())

        }
    }
}

#Preview {
    FontTest()
}
