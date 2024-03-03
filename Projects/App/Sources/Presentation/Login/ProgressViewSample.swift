//
//  ProgressViewSample.swift
//  SYM
//
//  Created by 박서연 on 2024/03/03.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ProgressViewSample: View {
    @State private var rotationAngle: Double = 0
    @State private var message: String = "어서와요\n오늘 하루도 수고했어요"
    @State private var animatedMessage: String = ""
    
        var body: some View {
            VStack(spacing: 40) {
                Image("SimiSmile2")
                    .resizable()
                    .frame(width: 200, height: 200)
//                    .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0.0, y: 0.001, z: 0.0))
//                    .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: rotationAngle)
//                    .onAppear {
//                        self.rotationAngle = 360
//                    }
                
                IntroChatBubble(message: message, animatedMessage: $animatedMessage)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .onDisappear {
                sleep(UInt32(1))
            }
        }
}

#Preview {
    ProgressViewSample()
}


struct IntroChatBubble: View {
    let message: String
    var delay: CGFloat = 50
    @Binding var animatedMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(animatedMessage)
                .font(PretendardFont.bodyMedium)
                .tracking(0.5)
                .lineSpacing(5.0)
                .multilineTextAlignment(.center)
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
