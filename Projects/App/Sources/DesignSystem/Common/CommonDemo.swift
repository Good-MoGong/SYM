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
            Text("사건 테스트")
                .setBackgroundColor(.systemPink)
            Text("모공모공의 하루 일기 테스트 문구입니다. 오늘은 24년도 1월 7일 일요일입니다.")
                .setBackgroundColor(.grayThird)
        }
    }
}

#Preview {
    CommonDemo()
}
