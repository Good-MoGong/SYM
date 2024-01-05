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

//    struct FontStyles {
//        static let h1 = Font.system(size: 24, weight: .bold)
//        static let h2 = Font.system(size: 20, weight: .semibold)
//        static let body = Font.system(size: 16, weight: .regular)
//    }
//}
//
//struct H1TextStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content.font(DesignSystem.FontStyles.h1)
//    }
//}
//
//struct H2TextStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content.font(DesignSystem.FontStyles.h2)
//    }
//}
//
//struct BodyTextStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content.font(DesignSystem.FontStyles.body)
//    }
}

// 확인 예제
struct FontTest: View {
    var body: some View {
        VStack {
            Text("H1 Text")
            // Color는 둘 중 하나의 방법으로 사용
                .foregroundStyle(DesignSystem.ColorStyles.symGray1)
            //  .modifier(PinkTextStyle())
                .modifier(H1TextStyle())

            Text("H2 Text")
                .foregroundStyle(DesignSystem.ColorStyles.symGray4)
                .modifier(H2TextStyle())

            Text("Body Text")
                .foregroundStyle(DesignSystem.ColorStyles.symPink)
                .modifier(BodyTextStyle())
        }
    }
}

#Preview {
    FontTest()
}
