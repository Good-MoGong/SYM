//
//  TextFieldView.swift
//  SYM
//
//  Created by 전민돌 on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct DefaultTextField: View {
    @State var nickname: String = ""

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 335, height: 53)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .cornerRadius(30)
            .overlay(
                TextField("", text: $nickname)
                    .padding(.leading, 20)
            )
    }
}

struct ErrorTextField: View {
    @State var nickname: String = "" // 추후에 @Binding으로 바꿔서 사용해야 할듯?

    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 335, height: 53)
                .background(.white)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .inset(by: 0.5)
                        .stroke(Color(red: 1, green: 0.36, blue: 0.36), lineWidth: 1) // merge하면 Color 이름으로 변경 필요
                )
                .overlay(
                    TextField("", text: $nickname)
                        .padding(.leading, 20)
                )
            VStack(alignment: .leading) {
                Text("사용할 수 없는 닉네임이에요")
                Text("닉네임을 다시 한번 확인해주세요")
            }
                .font(.footnote) // font 변경 필요
                .foregroundColor(Color(red: 1, green: 0.36, blue: 0.36)) // Color 변경 필요
                .padding(.leading)
        }
    }
}

#Preview {
    DefaultTextField()
}
