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
    case sentenceTitle
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
        case .brightWithStroke:
            content
                .frame(width: 99, height: 41) // subColor, WhiteWithStroke는 padding 값만 넣어서 글자 수에 따라서 크기가 변하지만,
                                              // 여기에만 frame 값을 넣어서 글자 수에 상관 없이 고정
                .background(Color.bright)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.sub, lineWidth: 1)
                )
        case .sentenceField:
            content
                .font(.medium(14))
                .lineSpacing(7)
                .padding(.horizontal, 17)
                .padding(.vertical, 23)
                .frame(maxWidth: .infinity, minHeight: 214, alignment: .topLeading) // 아이폰 12, 13 mini로 실행하면 200자가 다 나오지 않고 잘려서 minHeight로 변경
                .background(Color.bright)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.sub, lineWidth: 1)
                        .frame(maxWidth: .infinity, minHeight: 214) // 아이폰 12, 13 mini로 실행하면 200자가 다 나오지 않고 잘려서 minHeight로 변경
                )
        case .sentenceTitle:
            content
                .frame(width: UIScreen.main.bounds.width * 0.3, height: 37)
                .font(.bold(16))
                .background(Color.sub)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}

public extension Text {
    // 감정 단어 선택 : 핑크, 회색 백그라운드
    // 결과 카드 : 나의 기록, 나의 감정  백그라운드
    func setTextBackground(_ colorType: BackgroundType) -> some View {
        self.modifier(BackgroundView(type: colorType))
    }
}


