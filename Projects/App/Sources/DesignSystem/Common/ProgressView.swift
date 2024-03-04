//
//  ProgressView.swift
//  SYM
//
//  Created by 변상필 on 2/26/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ProgressView: View {
    @State private var isAnimating = true // 점의 움직임을 제어할 상태 변수
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                Text("시미가 답장 쓰는 중")
                    .font(PretendardFont.bold18)
                
                ForEach(0..<3) { index in
                    circle(delay: Double(index) * 0.2) // 각 점마다 0.3초씩 딜레이를 줍니다.
                }
            }
        }
        .onAppear {
            // 뷰가 나타날 때 애니메이션 시작
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
                isAnimating.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func circle(delay: Double) -> some View {
        Circle()
            .frame(width: 6, height: 6)
            .offset(y: isAnimating ? -5 : 0)
            .animation(.easeInOut.repeatForever().delay(delay), value: isAnimating)
    }
}

#Preview {
    ProgressView()
}
