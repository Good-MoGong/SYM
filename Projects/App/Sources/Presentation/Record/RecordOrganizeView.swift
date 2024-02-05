//
//  RecordOrganizeView.swift
//  SYM
//
//  Created by 전민돌 on 1/27/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct RecordOrganizeView: View {
    let sampleFeelings = ["즐거운", "매우 기쁜", "만족스러운", "놀라운", "화가 나는"] // 감정 샘플 데이터
    let sampleText = """
    푸른하늘처럼 투명하게 새벽공기처럼 청아하게 언제나 파란 희망으로 다가서는 너에게 나는 그런 사람이고 싶다. 들판에 핀 작은 풀꽃같이 바람에 날리는 어여쁜 민들레같이 잔잔한 미소와 작은 행복을 주는 사람 너에게 나는 그런 사람이고 싶다. 따스한 햇살이 되어시린 가슴으로 아파할 때 포근하게 감싸주며 위로가 되는 사람 너에게 나는 그런 사람이고 싶다. 긴 인생이
    """
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer(minLength: 33)
                    
                    Text("나의 감정")
                        .font(PretendardFont.h4Bold)
                        .padding(.leading, 20)
                        .padding(.bottom, -10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: Array(repeating: GridItem(), count: 1)) {
                            ForEach(sampleFeelings, id: \.self) { feeling in
                                Text(feeling)
                                    .setTextBackground(.brightWithStroke)
                                    .padding(.horizontal, 2)
                            }
                        }
                        .padding(.leading, 2)
                        .padding()
                    }
                    .padding(.bottom, 15)
                    
                    Text("나의 기록")
                        .font(PretendardFont.h4Bold)
                        .padding(.leading, 20)
                        .padding(.bottom, 7)
                    
                    ZStack {
                        Text(sampleText) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "사건")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        Text(sampleText) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "생각")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        Text(sampleText) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "행동")
                    }
                    .padding(.horizontal, 20)
                    
                    Button("완료") {
                        print("완료 버튼") // 추후에 action 추가 필요
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: true))
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("2023. 1. 28 일기") // 추후에 실제로 실제 날짜로 변경 필요
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    let screenSize = UIScreen.main.bounds.size.width
    
    func isResolutionSentenceTitle(title: String) -> some View {
        switch screenSize {
        case 375: // 4.7, 5.8인치
            Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 190)
                .padding(.bottom, 215)
        case 414: // 5.5, LCD 6.1, 6.5인치
            Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 215)
                .padding(.bottom, 215)
        case 390, 393: // OLED 6.1인치
            Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 200)
                .padding(.bottom, 215)
        case 428, 430: // 6.7인치
            Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 210)
                .padding(.bottom, 215)
        default: // mini 모델
            Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 165)
                .padding(.bottom, 230)
        }
    }
}

#Preview {
    RecordOrganizeView()
}
