//
//  Font.swift
//  SYM
//
//  Created by 변상필 on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

extension DesignSystem {
    struct FontStyles {
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
}

struct H1TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(DesignSystem.FontStyles.symH1)
    }
}

struct H2TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(DesignSystem.FontStyles.symH2)
    }
}

struct H3TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(DesignSystem.FontStyles.symH3)
    }
}

struct H4TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(DesignSystem.FontStyles.symH4)
    }
}

struct BodyTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(DesignSystem.FontStyles.symBody)
    }
}

struct SmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(DesignSystem.FontStyles.symSmall)
    }
}
