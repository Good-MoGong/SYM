//
//  TextEditor.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CustomTextEditorStyle: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
//    @Binding var contentCount: String
    
    func body(content: Content) -> some View {
        if text.isEmpty {
            ZStack(alignment: .topLeading) {
                content
                    .padding(15)
                    .background(Color.symGray1)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .scrollContentBackground(.hidden)
                    .font(PretendardFont.bodyMedium)
                Text(placeholder)
                    .lineSpacing(10)
                    .padding(20)
                    .padding(.top, 2)
                    .font(PretendardFont.bodyMedium)
                    .foregroundColor(Color.symGray3)
            }
        } else {
            ZStack(alignment: .bottomTrailing) {
                content
                    .padding(15)
                    .background(Color.symGray1)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .scrollContentBackground(.hidden)
                
                Text("\(text.count) / 200")
                    .font(PretendardFont.smallMedium)
                    .foregroundColor(Color.symGray4)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            /*
             // 글자수 없으면 이대로 가면 됨
             content
                 .padding(15)
                 .background(Color.symGray1)
                 .clipShape(RoundedRectangle(cornerRadius: 30))
                 .scrollContentBackground(.hidden)
             */
        }
    }
}

extension TextEditor {
    func customStyle(placeholder: String, userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput))
    }
}

struct FormDemo: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var text: String = ""
    private let placeholder: String = "예) 친구를 만나서 영화도 보고 맛있는 것도 먹었어"
    
    var body: some View {
        VStack {
            TextField("이름을 입력해주세요", text: $username)
                .customTF(type: .normal)
                .padding()

            TextField("이름을 입력해주세요", text: $password)
                .customTF(type: .error)
                .padding()
            
            TextEditor(text: $text)
                .customStyle(placeholder: placeholder, userInput: $text)
                .frame(height: 200)
                .padding()
        }
    }
}

#Preview {
    FormDemo()
}
