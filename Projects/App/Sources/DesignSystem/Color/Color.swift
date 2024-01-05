//
//  Color.swift
//  SYM
//
//  Created by 변상필 on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

// App Color DesignSystem

extension DesignSystem {
    struct ColorStyles {
        static let symPink = Color.init(hex: "FFD2D2")
        static let symBlack = Color.init(hex: "2D2D2D")
        static let symGray4 = Color.init(hex: "7E7D7A")
        static let symGray3 = Color.init(hex: "989898")
        static let symGray2 = Color.init(hex: "E5E5E5")
        static let symGray1 = Color.init(hex: "F1F1F1")
        static let symWhite = Color.init(hex: "FFFFFF")
    }
}

struct PinkTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symPink)
    }
}

struct BlackTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symBlack)
    }
}

struct Gray4TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symGray4)
    }
}

struct Gray3TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symGray3)
    }
}

struct Gray2TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symGray2)
    }
}

struct Gray1TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symGray1)
    }
}

struct WhiteTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundStyle(DesignSystem.ColorStyles.symWhite)
    }
}
