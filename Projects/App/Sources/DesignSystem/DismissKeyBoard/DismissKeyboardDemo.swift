//
//  DismissKeyboardDemo.swift
//  SYM
//
//  Created by 민근의 mac on 3/4/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct DismissKeyboardDemo: View {
    @State private var text: String = ""

    var body: some View {
        VStack {
            TextField("Type something", text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .dismissKeyboardOnTap() // 이 부분을 통해 사용할 수 있습니다.

            Text("You typed: \(text)")
        }
        .padding()
    }
}

#Preview {
    DismissKeyboardDemo()
}
