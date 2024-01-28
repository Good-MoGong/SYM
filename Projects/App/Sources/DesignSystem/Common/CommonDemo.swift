//
//  CommonDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CommonDemo: View {
    var body: some View {
        VStack {
            Text("즐거운")
                .setTextBackground(.subColor)
            Text("매우 기쁜")
                .setTextBackground(.whiteWithStroke)
            Text("만족스러운")
                .setTextBackground(.brightWithStroke)
            ZStack {
                Text("""
                푸른하늘처럼 투명하게 새벽공기처럼 청아하게 언제나 파란 희망으로 다가서는 너에게 나는 그런 사람이고 싶다. 들판에 핀 작은 풀꽃같이 바람에 날리는 어여쁜 민들레같이 잔잔한 미소와 작은 행복을 주는 사람 너에게 나는 그런 사람이고 싶다. 따스한 햇살이 되어시린 가슴으로 아파할 때 포근하게 감싸주며 위로가 되는 사람 너에게 나는 그런 사람이고 싶다. 긴 인생이
                """)
                .setTextBackground(.sentenceField)
                .padding(.horizontal, 20)
                
                Text("사건")
                    .setTextBackground(.settenceTitle)
                    .padding(.trailing, 170)
                    .padding(.bottom, 215)
            }
        }
    }
}

#Preview {
    CommonDemo()
}
