//
//  CommonDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CommonDemo: View {
    @State private var nickname = "김모공"
    var body: some View {
        VStack {
            Text("매우 기쁜")
                .setTextBackground(.subColor)
            Text("매우 기쁜")
                .setTextBackground(.whiteWithStroke)
        }
    }
}

#Preview {
    NavigationStack {
        CommonDemo()
    }
}
