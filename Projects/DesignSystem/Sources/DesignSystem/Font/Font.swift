//
//  Font.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

extension Font {
    static func bold(_ size: CGFloat) -> Font {
        return DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: size)
    }
    
    static func medium(_ size: CGFloat) -> Font {
        return DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: size)
    }
}
