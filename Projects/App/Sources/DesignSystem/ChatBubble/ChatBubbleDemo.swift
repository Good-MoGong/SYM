//
//  ChatBubbleDemo.swift
//  SYM
//
//  Created by 민근의 mac on 1/7/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ChatBubbleDemo: View {
    @State private var message: String = "오늘의 기분은 어때?"
    @State private var animatedMessage: String = ""

    var body: some View {
        VStack {
            ChatBubble(message: message, animatedMessage: $animatedMessage)
            Image(systemName: "person.fill")
                .font(.symH1)
        }
    }
}

#Preview {
    ChatBubbleDemo()
}
