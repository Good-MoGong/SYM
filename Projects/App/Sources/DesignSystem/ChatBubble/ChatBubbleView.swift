//
//  ChatBubbleView.swift
//  SYM
//
//  Created by 민근의 mac on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ChatBubbleView: View {
    
    let message: String
    private let delay: CGFloat = 50
    @Binding var animatedMessage: String
    
    var body: some View {
        Text(animatedMessage)
            .padding()
            .font(.symH4)
            .background(Color.symPink)
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            .overlay(alignment: .bottom) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(30))
                    .offset(y: 15)
                    .foregroundColor(.symPink)
            }
            .opacity(message.isEmpty ? 0 : 1)
            .task {
                await animate()
            }
            .padding()
    }
    private func animate() async {
        for char in message {
            animatedMessage.append(char)
            do {
                try await Task.sleep(for: .milliseconds(delay))
            } catch {
                // 예외가 발생한 경우 처리
                print("Sleep failed: \(error)")
            }
        }
    }
}

#Preview {
    ChatBubbleView(message: "오늘의 기분은 어때?", animatedMessage: .constant("오늘의 기분은 어때?"))
}
