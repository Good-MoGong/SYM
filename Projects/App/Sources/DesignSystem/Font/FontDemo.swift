//
//  FontDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import SwiftUI

/// 레거시 코드 - 삭제 예정(린다)
struct DesignSystem {
    static let primaryButtonColor = Color.blue
    static let primaryButtonTextColor = Color.white
}

// 확인 예제
struct FontTest: View {
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("28, PretendardFont-Bold")
                    .font(PretendardFont.h1Bold)
                
                Text("25, PretendardFont-Bold")
                    .font(PretendardFont.h2Bold)
                
                Text("20, PretendardFont-Bold")
                    .font(PretendardFont.h3Bold)
                
                Text("18, PretendardFont-Bold")
                    .font(PretendardFont.h4Bold)
                
                Text("16, PretendardFont-Bold")
                    .font(PretendardFont.h5Bold)
                
                Text("14, PretendardFont-Bold")
                    .font(PretendardFont.bodyBold)
                
                Text("16, PretendardFont-Bold")
                    .font(PretendardFont.smallBold)
            }
            
            Spacer().frame(height: 20)
            
            Group {
                Text("28, PretendardFont-Meduim")
                    .font(PretendardFont.h1Medium)
                
                Text("25, PretendardFont-Bold")
                    .font(PretendardFont.h2Medium)
                
                Text("20, PretendardFont-Bold")
                    .font(PretendardFont.h3Medium)
                
                Text("18, PretendardFont-Bold")
                    .font(PretendardFont.h4Medium)
                
                Text("16, PretendardFont-Bold")
                    .font(PretendardFont.h5Medium)
                
                Text("14, PretendardFont-Bold")
                    .font(PretendardFont.bodyMedium)
                
                Text("16, PretendardFont-Bold")
                    .font(PretendardFont.smallMedium)
            }
        }
    }
}

#Preview {
    FontTest()
}
