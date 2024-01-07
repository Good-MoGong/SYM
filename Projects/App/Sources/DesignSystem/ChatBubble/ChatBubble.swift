//
//  ChatBubble.swift
//  SYM
//
//  Created by 민근의 mac on 1/8/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ChatBubble: View {
    let message: String
    var delay: CGFloat = 50
    @Binding var animatedMessage: String
    
    var body: some View {
        Text(animatedMessage)
            .padding()
            .font(PretendardFont.h4Medium)
            .background(Color.symPink)
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
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
