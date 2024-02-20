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
    var userName: String = "모공모공"
    var title: String = "님을 위한 시미의 답장이 도착했어요"
    @Binding var animatedMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Text(userName)
                    .foregroundColor(.main)
                    .font(PretendardFont.h5Bold)
                Text(title)
                    .font(PretendardFont.h5Bold)
            }
            Text(animatedMessage)
                .font(PretendardFont.bodyMedium)
                .lineSpacing(5.0)
        }
        .padding()
        .background(Color.bright)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .opacity(message.isEmpty ? 0 : 1)
        .task {
            await animate()
        }
        .padding(.horizontal)
            
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
