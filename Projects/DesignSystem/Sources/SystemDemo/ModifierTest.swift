//
//  ModifierTest.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ModifierTest: View {
    var body: some View {
        Text("안녕하세요 테스트")
            .customModifierTest()
    }
}

struct ModifierTestText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

public extension Text {
    func customModifierTest() -> some View {
        self.modifier(ModifierTestText())
    }
}

#Preview {
    ModifierTest()
}
