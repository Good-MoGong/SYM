//
//  SimiView.swift
//  SYM
//
//  Created by 박서연 on 2024/03/01.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum SimiType {
    case nothingPast
    case nothingCurrent
    case nothingYesterday
    case exists
}

struct SimiView: View {
    private var simiType: SimiType = .exists
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("오늘의 기록")
                    .font(.bold(18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("오늘의 감정이 기록되지 않았어요 \n시미가 당신을 기다리고 있어요!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(2)
                    .font(.medium(14))
                
                Button {
                    print("감정기록하기 버튼 탭")
                } label: {
                    Text("감정 기록하기")
                        .foregroundColor(.white)
                        .font(.bold(16))
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .symWidth * 0.45)
                .background(Color.main)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 10)
            }
            
            Image("SimiMain")
                .resizable()
                .scaledToFit()
                .frame(width: .symWidth * 0.35, height: .symWidth * 0.35)
                
        }
        .padding(15)
        .background(Color.bright)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SimiView()
}
