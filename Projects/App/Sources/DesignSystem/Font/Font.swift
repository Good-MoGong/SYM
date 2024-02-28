//
//  Font.swift
//  SYM
//
//  Created by 변상필 on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

extension Font {
    static func bold(_ size: CGFloat) -> Font {
        return SYMFontFamily.Pretendard.bold.swiftUIFont(size: size)
    }
}

/// 디폴트 폰트 (PretendardFont)
struct PretendardFont {
    static let medium = "Pretendard-Medium"
    static let black = "Pretendard-Black"
    static let bold = "Pretendard-Bold"
    static let extrBold = "Pretendard-ExtraBold"
    static let extraLight = "Pretendard-ExtraLight"
    static let light = "Pretendard-Light"
    static let regular = "Pretendard-Regular"
    static let semiBold = "Pretendard-SemiBold"
    static let thin = "Pretendard-Thin"
    
    // MARK: - Medium+글꼴
    /// 28
    static let h1Medium = Font.custom(PretendardFont.medium, size: 28)
    /// 25
    static let h2Medium = Font.custom(PretendardFont.medium, size: 25)
    /// 20
    static let h3Medium = Font.custom(PretendardFont.medium, size: 20)
    /// 17
    static let h4Medium = Font.custom(PretendardFont.medium, size: 17)
    /// 16
    static let h5Medium = Font.custom(PretendardFont.medium, size: 16)
    /// 14
    static let bodyMedium = Font.custom(PretendardFont.medium, size: 14)
    /// 12
    static let smallMedium = Font.custom(PretendardFont.medium, size: 12)
    
    // MARK: - Bold+글꼴
    /// 30
    static let bold30 = Font.custom(PretendardFont.bold, size: 30)
    /// 28
    static let h1Bold = Font.custom(PretendardFont.bold, size: 28)
    /// 25
    static let h2Bold = Font.custom(PretendardFont.bold, size: 25)
    /// 20
    static let h3Bold = Font.custom(PretendardFont.bold, size: 20)
    /// 18
    static let bold18 = Font.custom(PretendardFont.bold, size: 18)
    /// 17
    static let h4Bold = Font.custom(PretendardFont.bold, size: 18)
    /// 16
    static let h5Bold = Font.custom(PretendardFont.bold, size: 16)
    /// 14
    static let bodyBold = Font.custom(PretendardFont.bold, size: 14)
    /// 12
    static let smallBold = Font.custom(PretendardFont.bold, size: 12)
}
