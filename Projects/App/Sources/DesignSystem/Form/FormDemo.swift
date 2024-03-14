//
//  FormDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo
// 사용예제
import SwiftUI

struct FormDemoTest: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            TextField("이름을 입력해주세요", text: $username)
                .customTF(type: .normal)
                .padding()

            TextField("이름을 입력해주세요", text: $password)
                .customTF(type: .error)
                .padding()
            
            TextEditor(text: $text)
                .customStyle(placeholder: TextEditorContent.writtingDiary.rawValue, userInput: $text)
                .frame(height: 200)
                .padding()
        }
    }
}

#Preview {
    FormDemoTest()
}
