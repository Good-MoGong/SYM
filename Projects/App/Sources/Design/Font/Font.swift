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
    
    static func medium(_ size: CGFloat) -> Font {
        return SYMFontFamily.Pretendard.medium.swiftUIFont(size: size)
    }
}
