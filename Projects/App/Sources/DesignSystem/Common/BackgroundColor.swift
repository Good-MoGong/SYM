//
//  CommonBackground.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

public enum BackgroundType {
    case systemPink
    case grayThird
}

struct BackgroundView: ViewModifier {
    let type: BackgroundType
    func body(content: Content) -> some View {
        switch type {
        case .systemPink:
            content
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.main)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        case .grayThird:
            content
                .padding(20)
                .background(Color.symGray1)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}

public extension Text {
    /// 일반 핑크/회색 백그라운드
    func setBackgroundColor(_ colorType: BackgroundType) -> some View {
        self.modifier(BackgroundView(type: colorType))
    }
}


