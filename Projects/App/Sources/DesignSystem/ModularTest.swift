//
//  ModularTest.swift
//  SYM
//
//  Created by 박서연 on 2024/03/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

struct ModularTest: View {
    var body: some View {
        Text("모듈화 테스트")
            .customModifierTest()
    }
}

#Preview {
    ModularTest()
}
