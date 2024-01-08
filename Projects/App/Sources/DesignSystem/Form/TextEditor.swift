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
    
    func body(content: Content) -> some View {
        if text.isEmpty {
            ZStack(alignment: .topLeading) {
                content
                    .padding(15)
                    .background(Color.symGray1)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
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
            content
                .padding(15)
                .background(Color(UIColor.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .scrollContentBackground(.hidden)
        }
    }
}

extension TextEditor {
    func customStyle(placeholder: String, userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput))
    }
}
