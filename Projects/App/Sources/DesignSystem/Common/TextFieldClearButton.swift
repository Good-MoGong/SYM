//
//  TextFieldClearButton.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if !text.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "multiply.circle")
                        }
                        .foregroundStyle(Color.symBlack)
                        .padding(.trailing, 10)
                    }
                }
            }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(TextFieldClearButton(text: text))
    }
}
