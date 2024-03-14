//
//  TextEditor.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum TextEditorContent: String, CaseIterable {
    // 사건 - 생각 - 행동
    case writtingDiary = "예) 오늘은 친구랑 조금 다투는 일이 있었다. 평상시와 다르지 않게 즐겁게 수다를 떨었는데 갑자기 섭섭했던 일화가 나오면서 투닥거렸고, 결국에는 언성까지 높아졌다."
    case writtingThink = "예) 나는 좋은 마음에 행동한 것이었는데, 그 동안 친구는 불편하다고 느끼고 있었다고 말해서 너무 당황스러웠고 섭섭하고 화도 났다."
    case writtingAction = "예) 결국 친구한테 따지듯이 말을 하게 되었고 서로 기분이 상해서 싸우다가 홧김에 자리를 박차고 나와 집으로 돌아왔다. 지금와서 돌아보니 내 잘못이었나 싶지만, 어떻게 해야 잘 해결할 수 있을지 모르겠다."
}

struct CustomTextEditorStyle: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    
    func body(content: Content) -> some View {
            content
                .padding(15)
                .background(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .lineSpacing(10)
                            .padding(20)
                            .padding(.top, 2)
                            .font(.medium(14))
                            .foregroundColor(Color.symGray3)
                    }
                }
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .background(Color.symGray1)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .font(.medium(14))
                .overlay(alignment: .bottomTrailing) {
                    Text("\(text.count) / 200")
                        .font(.medium(12))
                        .foregroundColor(Color.symGray4)
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

struct CustomTextEditorStyle2: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack (alignment: .bottomTrailing) {
            content
                .font(.medium(14))
                .lineSpacing(7)
                .padding(.horizontal, 17)
                .padding(.vertical, 23)
                .frame(maxWidth: .infinity, minHeight: 214)
                .background(Color.bright)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.sub, lineWidth: 1)
                        .frame(maxWidth: .infinity, minHeight: 214)
                )
            
            HStack {
                Text("\(text.count)")
                    .foregroundColor(Color.sub)
                Text("/ 200")
                    .foregroundColor(Color.symGray4)
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

struct CustomTextEditorStyle3: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .font(.medium(14))
            .lineSpacing(7)
            .padding(.horizontal, 17)
            .padding(.vertical, 23)
            .frame(maxWidth: .infinity, minHeight: 214)
            .background(Color.bright)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scrollContentBackground(.hidden)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.sub, lineWidth: 1)
                    .frame(maxWidth: .infinity, minHeight: 214)
            )
    }
}

extension TextEditor {
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

struct FormDemo: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var text: String = ""
    @State private var text2: String = ""
    @State private var text3: String = ""
    private let placeholder: String = "예) 친구를 만나서 영화도 보고 맛있는 것도 먹었어"
    
    var body: some View {
        ScrollView {
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
                
                TextEditor(text: $text2)
                    .customStyle2(userInput: $text2)
                    .frame(height: 200)
                    .padding()
                
                TextEditor(text: $text3)
                    .customStyle3(userInput: $text3)
                    .frame(height: 200)
                    .padding()
            }
        }
    }
}

#Preview {
    FormDemo()
}
