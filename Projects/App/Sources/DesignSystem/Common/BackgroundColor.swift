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
    case brightWithStroke
    case sentenceField
    case settenceTitle
//    case subColorTextEditor
}

struct BackgroundView: ViewModifier {
    let type: BackgroundType
    func body(content: Content) -> some View {
        switch type {
        case .subColor:
            content
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.sub)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        case .whiteWithStroke:
            content
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.symGray2, lineWidth: 2)
                )
        case .brightWithStroke:
            content
                .frame(width: 99, height: 41) // subColor, WhiteWithStroke는 padding 값만 넣어서 글자 수에 따라서 크기가 변하지만,
                                              // 여기에만 frame 값을 넣어서 글자 수에 상관 없이 고정되게 해보았습니다.
                .background(Color.bright)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.sub, lineWidth: 1)
                )
        case .sentenceField:
            content
                .font(PretendardFont.bodyMedium)
                .lineSpacing(7) // 피그마에는 4로 되어있는데 너무 좁아보여서 일단 7로 설정함
                .padding(.horizontal, 17)
                .padding(.vertical, 23)
                .frame(width: .infinity, height: 214)
                .background(Color.bright)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.sub, lineWidth: 1)
                        .frame(width: .infinity, height: 214)
                )
        case .settenceTitle:
            content
                .frame(width: 132, height: 37)
                .font(PretendardFont.h4Bold)
                .background(Color.sub)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
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


