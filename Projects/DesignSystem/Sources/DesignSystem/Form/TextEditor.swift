//
//  TextEditor.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

public struct CustomTextEditorStyle: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    
    public func body(content: Content) -> some View {
            content
                .padding(15)
                .background(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .lineSpacing(10)
                            .padding(20)
                            .padding(.top, 2)
                            .font(.medium(14))
                            .foregroundColor(Color.gray3_CCD2DA)
                    }
                }
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .background(Color.gray1_F3F5F8)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .font(.medium(14))
                .overlay(alignment: .bottomTrailing) {
                    Text("\(text.count) / 200")
                        .font(.medium(12))
                        .foregroundColor(Color.gray4_9BA3AE)
                        .padding(.trailing, 15)
                        .padding(.bottom, 15)
                        .onChange(of: text) { newValue in
                            if newValue.count > 200 {
                                text = String(newValue.prefix(200))
                            }
                        }
                }
    }
}

public struct CustomTextEditorStyle2: ViewModifier {
    
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        ZStack (alignment: .bottomTrailing) {
            content
                .font(.medium(14))
                .lineSpacing(7)
                .padding(.horizontal, 17)
                .padding(.vertical, 23)
                .frame(maxWidth: .infinity, minHeight: 214)
                .background(Color.bright_FFF3F3)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.sub_FFA9A9, lineWidth: 1)
                        .frame(maxWidth: .infinity, minHeight: 214)
                )
            
            HStack {
                Text("\(text.count)")
                    .foregroundColor(Color.sub_FFA9A9)
                Text("/ 200")
                    .foregroundColor(Color.gray4_9BA3AE)
            }
            .font(.medium(12))
            .padding(.trailing, 10)
            .padding(.bottom, 10)
            .onChange(of: text) { newValue in
                if newValue.count > 200 {
                    text = String(newValue.prefix(200))
                }
            }
        }
    }
}

public struct CustomTextEditorStyle3: ViewModifier {
    
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        content
            .font(.medium(14))
            .lineSpacing(7)
            .padding(.horizontal, 17)
            .padding(.vertical, 23)
            .frame(maxWidth: .infinity, minHeight: 214)
            .background(Color.bright_FFF3F3)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scrollContentBackground(.hidden)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.sub_FFA9A9, lineWidth: 1)
                    .frame(maxWidth: .infinity, minHeight: 214)
            )
    }
}

public extension TextEditor {
    func customStyle(placeholder: String, userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput))
    }
    
    func customStyle2(userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle2(text: userInput))
    }
    
    func customStyle3(userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle3(text: userInput))
    }
}
