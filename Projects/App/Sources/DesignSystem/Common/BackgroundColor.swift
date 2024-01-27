//
//  CommonBackground.swift
//  SYM
//
//  Created by 박서연 on 2024/01/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

public enum BackgroundType {
    case subColor
    case whiteWithStroke
//    case subColorTextEditor
}

struct BackgroundView: ViewModifier {
    let type: BackgroundType
    func body(content: Content) -> some View {
        switch type {
        case .subColor:
            content
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.sub)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        case .whiteWithStroke:
            content
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.symGray2, lineWidth: 2)
                )
//        case .subColorTextEditor:
//            content
//                .padding(.horizontal, 17)
//                .padding(.top, 23)
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.main, lineWidth: 1)
//                )
//                .background(Color.bright)
        }
    }
}

public extension Text {
    /// 일반 핑크/회색 백그라운드
    func setTextBackground(_ colorType: BackgroundType) -> some View {
        self.modifier(BackgroundView(type: colorType))
    }
}


