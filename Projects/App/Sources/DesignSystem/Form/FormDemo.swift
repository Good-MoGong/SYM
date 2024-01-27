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

enum TextEditorContent: String, CaseIterable {
    case writtingDiary = "예) 오늘은 오랜만에 고등학교 친구와 만나서 영화도 보고 밥도 먹었다. 이제는 서로 바빠져서 예전만큼 만나기는 힘들지만, 예전과 같은 친구의 모습이 보기 좋았다."
}

struct FormDemoTest: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var text: String = ""
    private let holderTest: String = "예) 친구를 만나서 영화도 보고 맛있는 것도 먹었어"
    
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
