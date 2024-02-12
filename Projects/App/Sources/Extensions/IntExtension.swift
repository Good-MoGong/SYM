//
//  IntExtension.swift
//  SYM
//
//  Created by 안지영 on 2/13/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

/// Int 천단위 콤마 제거
extension Int {
    func formatterStyle(_ numberStyle: NumberFormatter.Style) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = numberStyle
        return numberFommater.string(for: self)
    }
}
