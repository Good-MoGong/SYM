//
//  ChatBubble.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatBubble: View {
    let message: String
    var delay: CGFloat = 50
    var title: String = "시미의 따뜻한 공감 한마디"
    @Binding var animatedMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.bold(16))
            }
            Text(animatedMessage)
                .font(.medium(14))
                .tracking(0.5)
                .lineSpacing(5.0)
        }
        .padding()
        .background(Color.bright_FFF3F3)
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
                print("Sleep failed: \(error)")
            }
        }
    }
}
