//
//  CommonDoubleBtnView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/27.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

/// 팝업 뷰 생성시 겹치는 색상 뷰
struct CommonDoubleBtnView: View {
    @Binding var title: String
    @Binding var boldDesc: String
    @Binding var desc: String
    
    var body: some View {
        VStack {
            Spacer().frame(height: 12)
            Text(title)
                .font(PretendardFont.h3Bold)
            
            if !boldDesc.isEmpty {
                Spacer().frame(height: 10)
                Text(boldDesc)
                    .font(PretendardFont.h5Bold)
                    .foregroundColor(Color.errorRed)
                Spacer().frame(height: 10)
            }
            
            if !desc.isEmpty {
                Text(desc)
                    .font(PretendardFont.bodyMedium)
                    .foregroundColor(Color.errorRed)
                    .lineSpacing(1.5)
                    .multilineTextAlignment(.leading)
            }
            Spacer().frame(height: 40)
        }
    }
}

#Preview {
    CommonDoubleBtnView(title: .constant("title"), boldDesc: .constant("boldDesc"), desc: .constant("desc"))
}

struct CustomPopupModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 40)
        
        /*
         .padding(.horizontal, 20)
         .frame(maxWidth: .infinity)
         .padding(.top, 25)
         .padding(.bottom, 25)
         .background(Color.white)
         .cornerRadius(15)
         .padding(.horizontal, 60)
         */
    }
}

extension View {
    func customPopupModifier() -> some View {
        self.modifier(CustomPopupModifier())
    }
}
