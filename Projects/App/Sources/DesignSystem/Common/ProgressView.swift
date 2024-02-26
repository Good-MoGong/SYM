//
//  ProgressView.swift
//  SYM
//
//  Created by 변상필 on 2/26/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ProgressView: View {
    @State private var height: Double = 0.6

    var body: some View {
        VStack {
            Image("SimiCurious")
            HStack(alignment: .center) {
                Text("시미가 답장 쓰는 중")
                    .font(PretendardFont.bold18)
                
                ForEach(0..<3) { index in
                    circle(height: $height, delay: Double(index + 1) * 0.3)
                }
            }
        }
    }

    // 상단으로 점이 올라갔다 내려오는 뷰
    @ViewBuilder
    private func circle(height: Binding<Double>, delay: Double) -> some View {
        Circle()
            .frame(width: 6, height: 6)
            .animation(Animation.linear(duration: 0.6).repeatForever().delay(delay))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
                    height.wrappedValue = 1
                }
            }
            .offset(y: height.wrappedValue == 1 ? -4 : 4)
    }
}

#Preview {
    ProgressView()
}
