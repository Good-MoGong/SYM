//
//  Font.swift
//  SYM
//
//  Created by 변상필 on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI


extension Font {
    /// 28 .medium
    static let symH1 = Font.system(size: 28, weight: .medium)
    /// 25 .medium
    static let symH2 = Font.system(size: 25, weight: .medium)
    /// 20 .medium
    static let symH3 = Font.system(size: 20, weight: .medium)
    /// 18 .medium
    static let symH4 = Font.system(size: 18, weight: .medium)
    /// 16 .medium
    static let symH5 = Font.system(size: 16, weight: .medium)
    /// 14 .medium
    static let symBody = Font.system(size: 14, weight: .medium)
    /// 12 .medium
    static let symSmall = Font.system(size: 12, weight: .medium)
}

/// 디폴트 폰트 (PretendardFont)
struct PretendardFont {
    static let medium = "Pretendard-Medium"
    static let black = "Pretendard-Black"
    static let bold = "Pretendard-Bold"
    static let extrBold = "Pretendard-ExtraBold"
    static let extraLight = "Pretendard-ExtraLight.otf"
    static let light = "Pretendard-Light.otf"
    static let regular = "Pretendard-Regular.otf"
    static let semiBold = "Pretendard-SemiBold.otf"
    static let thin = "Pretendard-Thin.otf"
    
    // MARK: - Medium+글꼴
    /// 28
    static let h1Medium = Font.custom(PretendardFont.medium, size: 28)
    /// 25
    static let h2Medium = Font.custom(PretendardFont.medium, size: 25)
    /// 20
    static let h3Medium = Font.custom(PretendardFont.medium, size: 20)
    /// 18
    static let h4Medium = Font.custom(PretendardFont.medium, size: 18)
    /// 16
    static let h5Medium = Font.custom(PretendardFont.medium, size: 16)
    /// 14
    static let bodyMedium = Font.custom(PretendardFont.medium, size: 14)
    /// 12
    static let smallMedium = Font.custom(PretendardFont.medium, size: 12)
    
    // MARK: - Bold+글꼴
    /// 28
    static let h1Bold = Font.custom(PretendardFont.bold, size: 28)
    /// 25
    static let h2Bold = Font.custom(PretendardFont.bold, size: 25)
    /// 20
    static let h3Bold = Font.custom(PretendardFont.bold, size: 20)
    /// 18
    static let h4Bold = Font.custom(PretendardFont.bold, size: 18)
    /// 16
    static let h5Bold = Font.custom(PretendardFont.bold, size: 16)
    /// 14
    static let bodyBold = Font.custom(PretendardFont.bold, size: 14)
    /// 12
    static let smallBold = Font.custom(PretendardFont.bold, size: 12)
}
