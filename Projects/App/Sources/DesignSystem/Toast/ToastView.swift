//
//  ToastView.swift
//  SYM
//
//  Created by 민근의 mac on 2/13/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ToastView: View {
  
    var style: ToastStyle
    var message: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: style.iconStyle)
                .foregroundColor(style.themeColor)

            Text(message)
                .font(PretendardFont.bodyMedium)
        }
        .tint(Color.white)
        .foregroundColor(Color.white)
        .padding()
        .frame(minWidth: 0, maxWidth: .symWidth * 0.8)
        .background(Color.symGray5)
        .cornerRadius(15)
        
    }
}


#Preview {
    ToastView(style: .error, message: "감정단어는 최대 5개까지 선택할 수 있어요")
}

